{ config, lib, pkgs, ... }: {
  options = {
    services.ipp-usb = {
      enable = lib.mkEnableOption (lib.mdDoc "ipp-usb, a daemon to turn an USB printer/scanner supporting IPP everywhere (aka AirPrint, WSD, AirScan) into a locally accessible network printer/scanner");
    };
  };
  config = lib.mkIf config.services.ipp-usb.enable {
    systemd.services.ipp-usb = {
      description = "Daemon for IPP over USB printer support";
      after = [ "cups.service" "avahi-daemon.service" ];
      wants = [ "avahi-daemon.service" ];
      serviceConfig = {
        ExecStart = [ "${pkgs.ipp-usb}/bin/ipp-usb" ];
        Type = "simple";
        Restart = "on-failure";
        StateDirectory = "ipp-usb";
        LogsDirectory = "ipp-usb";

        # hardening.
        ProtectHome = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectControlGroups = true;
        MemoryDenyWriteExecute = true;
        # breaks the daemon, presumably because it messes with DeviceAllow
        ProtectClock = false;
        ProtectKernelTunables = true;
        ProtectKernelLogs = true;
        ProtectSystem = "strict";
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        PrivateMounts = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
        RemoveIPC = true;
        RestrictNamespaces = true;
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_NETLINK" "AF_INET" "AF_INET6" ];
        ProtectProc = "noaccess";
      };
    };

    # starts the systemd service
    services.udev.packages = [ pkgs.ipp-usb ];
    services.avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
    # enable printing and scanning by default, but not required.
    services.printing.enable = lib.mkDefault true;
    hardware.sane.enable = lib.mkDefault true;
    # so that sane discovers scanners
    hardware.sane.extraBackends = [ pkgs.sane-airscan ];
  };
}


