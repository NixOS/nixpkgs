{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.immich-public-proxy;
  format = pkgs.formats.json { };
in
{
  options.services.immich-public-proxy = {
    enable = lib.mkEnableOption "Immich Public Proxy";
    package = lib.mkPackageOption pkgs "immich-public-proxy" { };

    immichUrl = lib.mkOption {
      type = lib.types.str;
      description = "URL of the Immich instance";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "The port that IPP will listen on.";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the IPP port in the firewall";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
      };
      default = { };
      description = ''
        Configuration for IPP. See <https://github.com/alangrainger/immich-public-proxy/blob/main/README.md#additional-configuration> for options and defaults.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.immich-public-proxy = {
      description = "Immich public proxy for sharing albums publicly without exposing your Immich instance";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        IMMICH_URL = cfg.immichUrl;
        IPP_PORT = builtins.toString cfg.port;
        IPP_CONFIG = "${format.generate "config.json" cfg.settings}";
      };
      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        SyslogIdentifier = "ipp";
        User = "ipp";
        Group = "ipp";
        DynamicUser = true;
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 3;

        # Hardening
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateUsers = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    meta.maintainers = with lib.maintainers; [ jaculabilis ];
  };
}
