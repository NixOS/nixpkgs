{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.ircdHybrid;

  ircdService = pkgs.stdenv.mkDerivation rec {
    name = "ircd-hybrid-service";
    scripts = [ "=>/bin" ./control.in ];
    substFiles = [ "=>/conf" ./ircd.conf ];
    inherit (pkgs) ircdHybrid coreutils su iproute2 gnugrep procps;

    ipv6Enabled = boolToString config.networking.enableIPv6;

    inherit (cfg) serverName sid description adminEmail extraPort;

    cryptoSettings = (optionalString (cfg.rsaKey != null) ''
      rsa_private_key_file = "${cfg.rsaKey}";
    '') + (optionalString (cfg.certificate != null) ''
      ssl_certificate_file = "${cfg.certificate}";
    '');

    extraListen = map (ip:
      ''host = "'' + ip + ''
        ";
        port = 6665 .. 6669, '' + extraPort + "; ") cfg.extraIPs;

    builder = ./builder.sh;
  };

in {

  ###### interface

  options = {

    services.ircdHybrid = {

      enable = mkEnableOption "IRCD";

      serverName = mkOption {
        default = "hades.arpa";
        type = types.str;
        description = "\n          IRCD server name.\n        ";
      };

      sid = mkOption {
        default = "0NL";
        type = types.str;
        description =
          "\n          IRCD server unique ID in a net of servers.\n        ";
      };

      description = mkOption {
        default = "Hybrid-7 IRC server.";
        type = types.str;
        description = "\n          IRCD server description.\n        ";
      };

      rsaKey = mkOption {
        default = null;
        example = literalExpression "/root/certificates/irc.key";
        type = types.nullOr types.path;
        description = "\n          IRCD server RSA key.\n        ";
      };

      certificate = mkOption {
        default = null;
        example = literalExpression "/root/certificates/irc.pem";
        type = types.nullOr types.path;
        description =
          "\n          IRCD server SSL certificate. There are some limitations - read manual.\n        ";
      };

      adminEmail = mkOption {
        default = "<bit-bucket@example.com>";
        type = types.str;
        example = "<name@domain.tld>";
        description = "\n          IRCD server administrator e-mail.\n        ";
      };

      extraIPs = mkOption {
        default = [ ];
        example = [ "127.0.0.1" ];
        type = types.listOf types.str;
        description = "\n          Extra IP's to bind.\n        ";
      };

      extraPort = mkOption {
        default = "7117";
        type = types.str;
        description = "\n          Extra port to avoid filtering.\n        ";
      };

    };

  };

  ###### implementation

  config = mkIf config.services.ircdHybrid.enable {

    users.users.ircd = {
      description = "IRCD owner";
      group = "ircd";
      uid = config.ids.uids.ircd;
    };

    users.groups.ircd.gid = config.ids.gids.ircd;

    systemd.services.ircd-hybrid = {
      description = "IRCD Hybrid server";
      after = [ "started networking" ];
      wantedBy = [ "multi-user.target" ];
      script = "${ircdService}/bin/control start";
    };
  };
}
