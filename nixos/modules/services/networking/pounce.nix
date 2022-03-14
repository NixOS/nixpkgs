{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pounce;
  defaultUser = "pounce";
  configFile = pkgs.writeText "pounce" ''
    ${optionalString (cfg.sslCa != null) "local-ca = ${cfg.sslCa}"}
    local-host = ${cfg.hostAddress}
    local-port = ${toString cfg.hostPort}
    local-priv = ${cfg.sslKey}
    local-cert = ${cfg.sslCert}
    join = ${concatStringsSep "," cfg.joinChannels}
    ${optionalString (cfg.hashedPass != "") "local-pass = "+cfg.hashedPass}
    host = ${cfg.ircHost}
    port = ${toString cfg.ircHostPort}
    user = ${cfg.ircUser}
    nick = ${cfg.ircNick}
    ${optionalString (cfg.certFP != null) "client-cert = "+cfg.certFP+"\nsasl-external"}
    ${optionalString (cfg.ircPass != "") "pass = "+cfg.ircPass}
    ${cfg.extraConfig}
  '';
in
{
  options = {
    services.pounce = {
      enable = mkEnableOption "the Pounce IRC bouncer";

      user = mkOption {
        default = defaultUser;
        example = "john";
        type = types.str;
        description = ''
          The name of an existing user account to use to own the Pounce server
          process. If not specified, a default user will be created.
        '';
      };

      group = mkOption {
        default = defaultUser;
        example = "users";
        type = types.str;
        description = ''
          Group to own the Pounce process.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.pounce;
        defaultText = literalExpression "pkgs.pounce";
        description = ''
          Set version of pounce package to use.
        '';
      };

      hostAddress = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Where pounce should listen for incoming connections.
        '';
      };

      hostPort = mkOption {
        type = types.port;
        default = 6697;
        description = ''
          The port on which Pounce listens.
        '';
      };

      sslCa = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "~/.config/pounce/pouncecert.pem";
        description = ''
          Path for TLS Certificate for CertFP. Needed
          for logging to Pounce password-less.
        '';
      };

      sslKey = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/etc/letsencrypt/cert/private.key";
        description = ''
          Path to server TLS certificate key.
        '';
      };

      sslCert = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/etc/letsencrypt/cert/cert.crt";
        description = ''
           Path to server TLS certificate.
        '';
      };

      certFP = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/etc/pounce/libera-user.pem";
        description = ''
           Path to certFP certificate for login to IRC server.
        '';
      };

      hashedPass = mkOption {
        type = types.str;
        default = "";
        description = ''
          Use password instead of TLS certificate for login.
          Generate using: pounce -x
        '';
      };

      ircHost = mkOption {
        type = types.str;
        example = "irc.libera.chat";
        default = "";
        description = ''
          IRC Host to connect.
        '';
      };

      ircHostPort = mkOption {
        type = types.int;
        default = 6697;
        description = ''
          IRC Port to connect.
        '';
      };

      joinChannels = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          List of channel to join at startup
        '';
      };

      ircUser = mkOption {
        type = types.str;
        default = "";
        description = ''
          IRC user
        '';
      };

      ircNick = mkOption {
        type = types.str;
        default = "";
        description = ''
          IRC nickname
        '';
      };

      ircPass = mkOption {
        type = types.str;
        default = "";
        description = ''
          IRC password
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra configuration";
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.pounce = {
      description = "Pounce";
      after = [ "network-online.target" ];
      wantedBy  = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.pounce}/bin/pounce ${configFile}";
        Restart = "always";
        DynamicUser = true;
        StateDirectory = "pounce";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ heph2 ];
}
