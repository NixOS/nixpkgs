{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.clamav-unofficial-sigs;
in {
  options.services.clamav-unofficial-sigs = with types; {
    enable = mkEnableOption "Unofficial ClamAV signatures";

    extraConfig = mkOption {
      type = attrsOf str;
      description = "Extra key-value pairs to configure in user.conf";
      example = { malwarepatrol_receipt_code = "YOUR-RECEIPT-NUMBER"; };
      default = {};
    };

    extraConfigFiles = mkOption {
      type = listOf str;
      description = "Extra configuration files to include";
      default = [];
    };
  };

  config = mkIf cfg.enable {
    systemd.services.clamav-unofficial-sigs = {
      startAt = "hourly";
      description = "Update unofficial ClamAV signatures";

      serviceConfig = {
        ExecStart = "${pkgs.clamav-unofficial-sigs}/bin/clamav-unofficial-sigs";
        User = "clamav";
        Group = "clamav";
        StateDirectory = "clamav-unofficial-sigs";
        ReadWritePaths = [ "/var/lib/clamav/" ];

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;

        CapabilityBoundingSet = "";
        NoNewPrivileges = true;

        ProtectKernelModules = true;
        SystemCallArchitectures = "native";
        ProtectKernelLogs = true;
        ProtectClock = true;

        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";

        LockPersonality = true;
        ProtectHostname = true;
        RestrictRealtime = true;
        MemoryDenyWriteExecute = true;
        RestrictNamespaces = true;
        RemoveIPC = true;
        UMask = "0077";
      };
    };

    environment.etc."clamav-unofficial-sigs/master.conf".source = "${pkgs.clamav-unofficial-sigs}/etc/clamav-unofficial-sigs/master.conf";
    environment.etc."clamav-unofficial-sigs/os.conf".source = "${pkgs.clamav-unofficial-sigs}/etc/clamav-unofficial-sigs/os.conf";
    environment.etc."clamav-unofficial-sigs/user.conf".text = ''
      ${concatStringsSep "\n" (mapAttrsToList (k: v: ''${k}="${v}"'') cfg.extraConfig)}
      ${concatStringsSep "\n" (map (path: "source '${path}'") cfg.extraConfigFiles)}
    '';
  };
}
