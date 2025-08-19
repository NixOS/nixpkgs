{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.monado;

  runtimeManifest = "${cfg.package}/share/openxr/1/openxr_monado.json";
in
{
  options.services.monado = {
    enable = mkEnableOption "Monado user service";

    package = mkPackageOption pkgs "monado" { };

    defaultRuntime = mkOption {
      type = types.bool;
      description = ''
        Whether to enable Monado as the default OpenXR runtime on the system.

        Note that applications can bypass this option by setting an active
        runtime in a writable XDG_CONFIG_DIRS location like `~/.config`.
      '';
      default = false;
      example = true;
    };

    forceDefaultRuntime = mkOption {
      type = types.bool;
      description = ''
        Whether to ensure that Monado is the active runtime set for the current
        user.

        This replaces the file `XDG_CONFIG_HOME/openxr/1/active_runtime.json`
        when starting the service.
      '';
      default = false;
      example = true;
    };

    highPriority =
      mkEnableOption "high priority capability for monado-service" // mkOption { default = true; };
  };

  config = mkIf cfg.enable {
    security.wrappers."monado-service" = mkIf cfg.highPriority {
      setuid = false;
      owner = "root";
      group = "root";
      # cap_sys_nice needed for asynchronous reprojection
      capabilities = "cap_sys_nice+eip";
      source = lib.getExe' cfg.package "monado-service";
    };

    services.udev.packages = with pkgs; [ xr-hardware ];

    systemd.user = {
      services.monado = {
        description = "Monado XR runtime service module";
        requires = [ "monado.socket" ];
        conflicts = [ "monado-dev.service" ];

        unitConfig.ConditionUser = "!root";

        environment = {
          # Default options
          # https://gitlab.freedesktop.org/monado/monado/-/blob/4548e1738591d0904f8db4df8ede652ece889a76/src/xrt/targets/service/monado.in.service#L12
          XRT_COMPOSITOR_LOG = mkDefault "debug";
          XRT_PRINT_OPTIONS = mkDefault "on";
          IPC_EXIT_ON_DISCONNECT = mkDefault "off";
          # Needed to avoid libbasalt.so: cannot open shared object file: No such file or directory
          VIT_SYSTEM_LIBRARY_PATH = mkDefault "${pkgs.basalt-monado}/lib/libbasalt.so";
        };

        preStart = mkIf cfg.forceDefaultRuntime ''
          XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"
          targetDir="$XDG_CONFIG_HOME/openxr/1"
          activeRuntimePath="$targetDir/active_runtime.json"

          echo "Note: Replacing active runtime at '$activeRuntimePath'"
          mkdir --parents "$targetDir"
          ln --symbolic --force ${runtimeManifest} "$activeRuntimePath"
        '';

        serviceConfig = {
          ExecStart =
            if cfg.highPriority then
              "${config.security.wrapperDir}/monado-service"
            else
              lib.getExe' cfg.package "monado-service";
          Restart = "no";
        };

        restartTriggers = [ cfg.package ];
      };

      sockets.monado = {
        description = "Monado XR service module connection socket";
        conflicts = [ "monado-dev.service" ];

        unitConfig.ConditionUser = "!root";

        socketConfig = {
          ListenStream = "%t/monado_comp_ipc";
          RemoveOnStop = true;

          # If Monado crashes while starting up, we want to close incoming OpenXR connections
          FlushPending = true;
        };

        restartTriggers = [ cfg.package ];

        wantedBy = [ "sockets.target" ];
      };
    };

    environment.systemPackages = [ cfg.package ];
    environment.pathsToLink = [ "/share/openxr" ];

    hardware.graphics.extraPackages = [ pkgs.monado-vulkan-layers ];

    environment.etc."xdg/openxr/1/active_runtime.json" = mkIf cfg.defaultRuntime {
      source = runtimeManifest;
    };
  };

  meta.maintainers = with lib.maintainers; [ Scrumplex ];
}
