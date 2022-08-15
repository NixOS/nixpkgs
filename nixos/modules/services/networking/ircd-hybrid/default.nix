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

    inherit (cfg) serverName sid description adminEmail
            extraPort;

    cryptoSettings =
      (optionalString (cfg.rsaKey != null) "rsa_private_key_file = \"${cfg.rsaKey}\";\n") +
      (optionalString (cfg.certificate != null) "ssl_certificate_file = \"${cfg.certificate}\";\n");

    extraListen = map (ip: "host = \""+ip+"\";\nport = 6665 .. 6669, "+extraPort+"; ") cfg.extraIPs;

    builder = ./builder.sh;
  };

in

{

  ###### interface

  options = {

    services.ircdHybrid = {

      enable = mkEnableOption "IRCD";

      serverName = mkOption {
        default = "hades.arpa";
        type = types.str;
        description = lib.mdDoc ''
          IRCD server name.
        '';
      };

      sid = mkOption {
        default = "0NL";
        type = types.str;
        description = lib.mdDoc ''
          IRCD server unique ID in a net of servers.
        '';
      };

      description = mkOption {
        default = "Hybrid-7 IRC server.";
        type = types.str;
        description = lib.mdDoc ''
          IRCD server description.
        '';
      };

      rsaKey = mkOption {
        default = null;
        example = literalExpression "/root/certificates/irc.key";
        type = types.nullOr types.path;
        description = lib.mdDoc ''
          IRCD server RSA key.
        '';
      };

      certificate = mkOption {
        default = null;
        example = literalExpression "/root/certificates/irc.pem";
        type = types.nullOr types.path;
        description = lib.mdDoc ''
          IRCD server SSL certificate. There are some limitations - read manual.
        '';
      };

      adminEmail = mkOption {
        default = "<bit-bucket@example.com>";
        type = types.str;
        example = "<name@domain.tld>";
        description = lib.mdDoc ''
          IRCD server administrator e-mail.
        '';
      };

      extraIPs = mkOption {
        default = [];
        example = ["127.0.0.1"];
        type = types.listOf types.str;
        description = lib.mdDoc ''
          Extra IP's to bind.
        '';
      };

      extraPort = mkOption {
        default = "7117";
        type = types.str;
        description = lib.mdDoc ''
          Extra port to avoid filtering.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.ircdHybrid.enable {

    users.users.ircd =
      { description = "IRCD owner";
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
