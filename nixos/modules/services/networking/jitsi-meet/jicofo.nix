{ config, pkgs, lib, ... }:

with pkgs;
with lib;

let
  cfg = config.services.jitsi-meet.jicofo;
in {
  options = {
    services.jitsi-meet.jicofo = {
      enable = mkEnableOption "JiCoFo";

      user = mkOption {
        type = types.str;
        default = "jicofo";
        description = ''
          User name under which JiCoFo shall be run.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = ''
          Group under which JiCoFo shall be run.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 5347;
        description = ''
          Sets the port of the XMPP server.
        '';
      };

      host = mkOption {
        type = types.nullOr types.str;
        default = if cfg.domain != null then cfg.domain else "localhost";
        description = ''
          Sets the hostname of the XMPP server.
        '';
      };

      secret = mkOption {
        type = types.str;
        description = ''
          Sets the shared secret used to authenticate to the XMPP server.
        '';
      };

      domain = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Sets the XMPP domain.
        '';
      };

      subdomain = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Sets the sub-domain used to bind JVB XMPP component.
        '';
      };

      userDomain = mkOption {
        type = types.str;
        default = "auth.localhost";
        description = ''
          Specifies the name of XMPP domain used by the focus user to login.
        '';
      };

      userName = mkOption {
        type = types.str;
        default = "focus@${cfg.userDomain}";
        description = ''
          Specifies the username used by the focus XMPP user to login.
        '';
      };

      userPassword = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Specifies the password used by focus XMPP user to login. If not provided then focus user will use anonymous authentication method.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open port in firewall for incoming connections.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = optional cfg.openFirewall cfg.port;

    users.extraUsers = optional (cfg.user == "jicofo") {
      name = cfg.user;
      home = "/home/${cfg.user}";
      description = "JiCoFo user";
      createHome = true;
    };

    systemd.services.jicofo = {
      description = "JiCoFo";
      path  = [ pkgs.jre ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStartPre = "+${pkgs.prosody}/bin/prosodyctl register ${cfg.userName} ${cfg.userDomain} ${optionalString (cfg.userPassword != null) cfg.userPassword}";
        ExecStart = ''
          ${pkgs.jicofo}/bin/jicofo \
          --host=${cfg.host} \
          --port=${toString cfg.port} \
          --user_domain=${cfg.userDomain} \
          --user_name=${cfg.userName} \
          --secret=${cfg.secret} \
          ${optionalString (cfg.subdomain != null) "--subdomain=${cfg.subdomain}"} ${optionalString (cfg.userPassword != null) "--user_password=${cfg.userPassword}"} ${optionalString (cfg.domain != null) "--domain=${cfg.domain}"}
        '';
        Restart  = "always";
        PrivateTmp = true;
        WorkingDirectory = "/tmp";
      };
    };
  };
}
