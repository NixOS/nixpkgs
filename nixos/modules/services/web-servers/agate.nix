{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.agate;
in
{
  options = {
    services.agate = {
      enable = lib.mkEnableOption "Agate Server";

      package = lib.mkPackageOption pkgs "agate" { };

      addresses = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "0.0.0.0:1965" ];
        description = ''
          Addresses to listen on, IP:PORT, if you haven't disabled forwarding
          only set IPv4.
        '';
      };

      contentDir = lib.mkOption {
        default = "/var/lib/agate/content";
        type = lib.types.path;
        description = "Root of the content directory.";
      };

      certificatesDir = lib.mkOption {
        default = "/var/lib/agate/certificates";
        type = lib.types.path;
        description = "Root of the certificate directory.";
      };

      hostnames = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
        description = ''
          Domain name of this Gemini server, enables checking hostname and port
          in requests. (multiple occurrences means basic vhosts)
        '';
      };

      language = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = "RFC 4646 Language code for text/gemini documents.";
      };

      onlyTls_1_3 = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Only use TLSv1.3 (default also allows TLSv1.2).";
      };

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "" ];
        example = [ "--log-ip" ];
        description = "Extra arguments to use running agate.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # available for generating certs by hand
    # it can be a bit arduous with openssl
    environment.systemPackages = [ cfg.package ];

    systemd.services.agate = {
      description = "Agate";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network.target"
        "network-online.target"
      ];

      script =
        let
          prefixKeyList =
            key: list:
            lib.concatMap (v: [
              key
              v
            ]) list;
          addresses = prefixKeyList "--addr" cfg.addresses;
          hostnames = prefixKeyList "--hostname" cfg.hostnames;
        in
        ''
          exec ${cfg.package}/bin/agate ${
            lib.escapeShellArgs (
              [
                "--content"
                "${cfg.contentDir}"
                "--certs"
                "${cfg.certificatesDir}"
              ]
              ++ addresses
              ++ (lib.optionals (cfg.hostnames != [ ]) hostnames)
              ++ (lib.optionals (cfg.language != null) [
                "--lang"
                cfg.language
              ])
              ++ (lib.optionals cfg.onlyTls_1_3 [ "--only-tls13" ])
              ++ (lib.optionals (cfg.extraArgs != [ ]) cfg.extraArgs)
            )
          }
        '';

      serviceConfig = {
        Restart = "always";
        RestartSec = "5s";
        DynamicUser = true;
        StateDirectory = "agate";

        # Security options:
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";

        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";

        LockPersonality = true;

        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = true;

        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;

        RestrictNamespaces = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictRealtime = true;

        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@cpu-emulation"
          "~@debug"
          "~@keyring"
          "~@memlock"
          "~@obsolete"
          "~@privileged"
          "~@setuid"
        ];
      };
    };
  };
}
