{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.agate;
in
{
  options = {
    services.agate = {
      enable = mkEnableOption "Agate Server";

      package = mkOption {
        type = types.package;
        default = pkgs.agate;
        defaultText = literalExpression "pkgs.agate";
        description = lib.mdDoc "The package to use";
      };

      addresses = mkOption {
        type = types.listOf types.str;
        default = [ "0.0.0.0:1965" ];
        description = lib.mdDoc ''
          Addresses to listen on, IP:PORT, if you haven't disabled forwarding
          only set IPv4.
        '';
      };

      contentDir = mkOption {
        default = "/var/lib/agate/content";
        type = types.path;
        description = lib.mdDoc "Root of the content directory.";
      };

      certificatesDir = mkOption {
        default = "/var/lib/agate/certificates";
        type = types.path;
        description = lib.mdDoc "Root of the certificate directory.";
      };

      hostnames = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = lib.mdDoc ''
          Domain name of this Gemini server, enables checking hostname and port
          in requests. (multiple occurences means basic vhosts)
        '';
      };

      language = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = lib.mdDoc "RFC 4646 Language code for text/gemini documents.";
      };

      onlyTls_1_3 = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Only use TLSv1.3 (default also allows TLSv1.2).";
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ "" ];
        example = [ "--log-ip" ];
        description = lib.mdDoc "Extra arguments to use running agate.";
      };
    };
  };

  config = mkIf cfg.enable {
    # available for generating certs by hand
    # it can be a bit arduous with openssl
    environment.systemPackages = [ cfg.package ];

    systemd.services.agate = {
      description = "Agate";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "network-online.target" ];

      script =
        let
          prefixKeyList = key: list: concatMap (v: [ key v ]) list;
          addresses = prefixKeyList "--addr" cfg.addresses;
          hostnames = prefixKeyList "--hostname" cfg.hostnames;
        in
        ''
          exec ${cfg.package}/bin/agate ${
            escapeShellArgs (
              [
                "--content" "${cfg.contentDir}"
                "--certs" "${cfg.certificatesDir}"
              ] ++
              addresses ++
              (optionals (cfg.hostnames != []) hostnames) ++
              (optionals (cfg.language != null) [ "--lang" cfg.language ]) ++
              (optionals cfg.onlyTls_1_3 [ "--only-tls13" ]) ++
              (optionals (cfg.extraArgs != []) cfg.extraArgs)
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
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
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
