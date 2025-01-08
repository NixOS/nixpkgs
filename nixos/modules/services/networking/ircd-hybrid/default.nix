{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.ircdHybrid;

  ircdService = pkgs.stdenv.mkDerivation rec {
    name = "ircd-hybrid-service";
    scripts = [
      "=>/bin"
      ./control.in
    ];
    substFiles = [
      "=>/conf"
      ./ircd.conf
    ];
    inherit (pkgs)
      ircdHybrid
      coreutils
      su
      iproute2
      gnugrep
      procps
      ;

    ipv6Enabled = lib.boolToString config.networking.enableIPv6;

    inherit (cfg)
      serverName
      sid
      description
      adminEmail
      extraPort
      ;

    cryptoSettings =
      (lib.optionalString (cfg.rsaKey != null) "rsa_private_key_file = \"${cfg.rsaKey}\";\n")
      + (lib.optionalString (cfg.certificate != null) "ssl_certificate_file = \"${cfg.certificate}\";\n");

    extraListen = map (
      ip: "host = \"" + ip + "\";\nport = 6665 .. 6669, " + extraPort + "; "
    ) cfg.extraIPs;

    builder = ./builder.sh;
  };

in

{

  ###### interface

  options = {

    services.ircdHybrid = {

      enable = lib.mkEnableOption "IRCD";

      serverName = lib.mkOption {
        default = "hades.arpa";
        type = lib.types.str;
        description = ''
          IRCD server name.
        '';
      };

      sid = lib.mkOption {
        default = "0NL";
        type = lib.types.str;
        description = ''
          IRCD server unique ID in a net of servers.
        '';
      };

      description = lib.mkOption {
        default = "Hybrid-7 IRC server.";
        type = lib.types.str;
        description = ''
          IRCD server description.
        '';
      };

      rsaKey = lib.mkOption {
        default = null;
        example = lib.literalExpression "/root/certificates/irc.key";
        type = lib.types.nullOr lib.types.path;
        description = ''
          IRCD server RSA key.
        '';
      };

      certificate = lib.mkOption {
        default = null;
        example = lib.literalExpression "/root/certificates/irc.pem";
        type = lib.types.nullOr lib.types.path;
        description = ''
          IRCD server SSL certificate. There are some limitations - read manual.
        '';
      };

      adminEmail = lib.mkOption {
        default = "<bit-bucket@example.com>";
        type = lib.types.str;
        example = "<name@domain.tld>";
        description = ''
          IRCD server administrator e-mail.
        '';
      };

      extraIPs = lib.mkOption {
        default = [ ];
        example = [ "127.0.0.1" ];
        type = lib.types.listOf lib.types.str;
        description = ''
          Extra IP's to bind.
        '';
      };

      extraPort = lib.mkOption {
        default = "7117";
        type = lib.types.str;
        description = ''
          Extra port to avoid filtering.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf config.services.ircdHybrid.enable {

    users.users.ircd = {
      description = "IRCD owner";
      group = "ircd";
      uid = config.ids.uids.ircd;
    };

    users.groups.ircd.gid = config.ids.gids.ircd;

    systemd.services.ircd-hybrid = {
      description = "IRCD Hybrid server";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      script = "${ircdService}/bin/control start";
    };
  };
}
