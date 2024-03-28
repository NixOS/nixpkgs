{ config, pkgs, lib, ... }:

let
  cfg = config.services.wivrn;
  inherit (lib) mkIf mkEnableOption mkPackageOption mkOption mkDefault mdDoc types getExe' maintainers;
in
{
  options = {
    services.wivrn = {
      enable = mkEnableOption "WiVRn, an OpenXR streaming application";

      package = mkPackageOption pkgs "wivrn" { };

      openFirewall = mkEnableOption "the default ports in the firewall for the WiVRn server";

      defaultRuntime = mkEnableOption ''
        WiVRn Monado as the default OpenXR runtime on the system. The config can be found at `/etc/xdg/openxr/1/active_runtime.json`.

        Note that applications can bypass this option by setting an active
        runtime in a writable XDG_CONFIG_DIRS location like `~/.config`
      '' // { default = true; };

      highPriority = mkEnableOption "high priority capability for wivrn-server" // { default = true; };

      monadoEnvironment = mkOption {
        type = types.attrsOf types.str;
        description = mdDoc "Environment variables passed to Monado.";
        # Default options
        # https://gitlab.freedesktop.org/monado/monado/-/blob/4548e1738591d0904f8db4df8ede652ece889a76/src/xrt/targets/service/monado.in.service#L12
        default = {
          XRT_COMPOSITOR_LOG = "debug";
          XRT_PRINT_OPTIONS = "on";
          IPC_EXIT_ON_DISCONNECT = "off";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    security.wrappers."wivrn-server" = mkIf cfg.highPriority {
      setuid = false;
      owner = "root";
      group = "root";
      # cap_sys_nice needed for asynchronous reprojection
      capabilities = "cap_sys_nice+eip";
      source = getExe' cfg.package "wivrn-server";
    };

    systemd.user = {
      services.wivrn = {
        description = "WiVRn XR runtime service module";
        requires = [ "wivrn.socket" ];
        unitConfig.ConditionUser = "!root";
        environment = cfg.monadoEnvironment // {
          XRT_COMPOSITOR_LOG = if builtins.hasAttr "XRT_COMPOSITOR_LOG" cfg.monadoEnvironment then cfg.monadoEnvironment.XRT_COMPOSITOR_LOG else "debug";
          XRT_PRINT_OPTIONS = if builtins.hasAttr "XRT_PRINT_OPTIONS" cfg.monadoEnvironment then cfg.monadoEnvironment.XRT_PRINT_OPTIONS else "on";
          IPC_EXIT_ON_DISCONNECT = if builtins.hasAttr "IPC_EXIT_ON_DISCONNECT" cfg.monadoEnvironment then cfg.monadoEnvironment.IPC_EXIT_ON_DISCONNECT else "off";
        };
        serviceConfig = {
          ExecStart =
            if cfg.highPriority
            then "${config.security.wrapperDir}/wivrn-server"
            else getExe' cfg.package "wivrn-server";
          Restart = "no";
        };
        restartTriggers = [ cfg.package ];
        wantedBy = [ "sockets.target" ];
      };

      sockets.wivrn = {
        description = "WiVRn XR service module connection socket";
        unitConfig.ConditionUser = "!root";
        socketConfig = {
          ListenStream = "%t/wivrn_comp_ipc";
          RemoveOnStop = true;
          # If WiVRn crashes while starting up, we want to close incoming OpenXR connections
          FlushPending = true;
        };
        restartTriggers = [ cfg.package ];
        wantedBy = [ "sockets.target" ];
      };
    };

    services = {
      udev.packages = with pkgs; [ xr-hardware ];
      avahi = {
        enable = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 9757 ];
      allowedUDPPorts = [ 9757 ];
    };

    environment = {
      systemPackages = [ cfg.package ];
      pathsToLink = [ "/share/openxr" ];
      etc."xdg/openxr/1/active_runtime.json" = mkIf cfg.defaultRuntime {
        source = "${cfg.package}/share/openxr/1/openxr_wivrn.json";
      };
    };
  };
  meta.maintainers = with maintainers; [ passivelemon ];
}
