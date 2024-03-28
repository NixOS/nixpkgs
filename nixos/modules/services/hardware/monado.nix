{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkAliasOptionModule mkDefault mkEnableOption mkIf mkOption mkPackageOption types;
  cfg = config.services.monado;
in
{
  options.services.monado = {
    enable = mkEnableOption "Monado user service";

    package = mkPackageOption pkgs "monado" { };

    defaultRuntime = mkEnableOption ''
        WiVRn Monado as the default OpenXR runtime on the system. The config can be found at `/etc/xdg/openxr/1/active_runtime.json`.

        Note that applications can bypass this option by setting an active
        runtime in a writable XDG_CONFIG_DIRS location like `~/.config`
      '' // { default = true; };

    highPriority = mkEnableOption "high priority capability for monado-service" // mkOption { default = true; };
  };

  imports = [
    (mkAliasOptionModule ["services" "monado" "environment"] ["systemd" "user" "services" "monado" "environment"])
  ];

  config = mkIf cfg.enable {
    security.wrappers."monado-service" = mkIf cfg.highPriority {
      setuid = false;
      owner = "root";
      group = "root";
      # cap_sys_nice needed for asynchronous reprojection
      capabilities = "cap_sys_nice+eip";
      source = lib.getExe' cfg.package "monado-service";
    };

    systemd.user = {
      services.monado = {
        description = "Monado XR runtime service module";
        requires = [ "monado.socket" ];
        conflicts = [ "monado-dev.service" ];
        unitConfig.ConditionUser = "!root";
        serviceConfig = {
          ExecStart =
            if cfg.highPriority
            then "${config.security.wrapperDir}/monado-service"
            else lib.getExe' cfg.package "monado-service";
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

    services = {
      monado.environment = {
        # Default options
        # https://gitlab.freedesktop.org/monado/monado/-/blob/4548e1738591d0904f8db4df8ede652ece889a76/src/xrt/targets/service/monado.in.service#L12
        XRT_COMPOSITOR_LOG = mkDefault "debug";
        XRT_PRINT_OPTIONS = mkDefault "on";
        IPC_EXIT_ON_DISCONNECT = mkDefault "off";
      };
      udev.packages = with pkgs; [ xr-hardware ];
    };

    environment = {
      systemPackages = [ cfg.package ];
      pathsToLink = [ "/share/openxr" ];
      etc."xdg/openxr/1/active_runtime.json" = mkIf cfg.defaultRuntime {
        source = "${cfg.package}/share/openxr/1/openxr_monado.json";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ Scrumplex ];
}
