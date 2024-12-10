{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.clatd;

  settingsFormat = pkgs.formats.keyValue { };

  configFile = settingsFormat.generate "clatd.conf" cfg.settings;
in
{
  options = {
    services.clatd = {
      enable = mkEnableOption "clatd";

      package = mkPackageOption pkgs "clatd" { };

      settings = mkOption {
        type = types.submodule (
          { name, ... }:
          {
            freeformType = settingsFormat.type;
          }
        );
        default = { };
        example = literalExpression ''
          {
            plat-prefix = "64:ff9b::/96";
          }
        '';
        description = ''
          Configuration of clatd. See [clatd Documentation](https://github.com/toreanderson/clatd/blob/master/README.pod#configuration).
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.clatd = {
      description = "464XLAT CLAT daemon";
      documentation = [ "man:clatd(8)" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      startLimitIntervalSec = 0;

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/clatd -c ${configFile}";

        # Hardening
        CapabilityBoundingSet = [
          "CAP_NET_ADMIN"
        ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectProc = "invisible";
        ProtectSystem = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@network-io"
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
      };
    };
  };
}
