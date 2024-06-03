{ config, pkgs, lib, ... }:

let
  inherit (lib) mkAliasOptionModule mkIf mkEnableOption mkPackageOption mkOption mkDefault types getExe' maintainers;
  cfg = config.services.wivrn;
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
    };
  };

  imports = [
    (mkAliasOptionModule [ "services" "wivrn" "monadoEnvironment" ] [ "systemd" "user" "services" "wivrn" "environment" ])
  ];

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
      wivrn.monadoEnvironment = {
        # Default options
        # https://gitlab.freedesktop.org/monado/monado/-/blob/4548e1738591d0904f8db4df8ede652ece889a76/src/xrt/targets/service/monado.in.service#L12
        XRT_COMPOSITOR_LOG = mkDefault "debug";
        XRT_PRINT_OPTIONS = mkDefault "on";
        IPC_EXIT_ON_DISCONNECT = mkDefault "off";
      };
      udev.packages = with pkgs; [ xr-hardware ]; # WiVRn can be used with some wired headsets
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
