{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.icecast;
  configFile = pkgs.writeText "icecast.xml" ''
    <icecast>
      <hostname>${cfg.hostname}</hostname>

      <authentication>
        <admin-user>${cfg.admin.user}</admin-user>
        <admin-password>${cfg.admin.password}</admin-password>
      </authentication>

      <paths>
        <logdir>${cfg.logDir}</logdir>
        <adminroot>${pkgs.icecast}/share/icecast/admin</adminroot>
        <webroot>${pkgs.icecast}/share/icecast/web</webroot>
        <alias source="/" dest="/status.xsl"/>
      </paths>

      <listen-socket>
        <port>${toString cfg.listen.port}</port>
        <bind-address>${cfg.listen.address}</bind-address>
      </listen-socket>

      <security>
        <chroot>0</chroot>
        <changeowner>
            <user>${cfg.user}</user>
            <group>${cfg.group}</group>
        </changeowner>
      </security>

      ${cfg.extraConf}
    </icecast>
  '';
in
{

  ###### interface

  options = {

    services.icecast = {

      enable = mkEnableOption "Icecast server";

      hostname = mkOption {
        type = types.nullOr types.str;
        description = "DNS name or IP address that will be used for the stream directory lookups or possibly the playlist generation if a Host header is not provided.";
        default = config.networking.domain;
        defaultText = literalExpression "config.networking.domain";
      };

      admin = {
        user = mkOption {
          type = types.str;
          description = "Username used for all administration functions.";
          default = "admin";
        };

        password = mkOption {
          type = types.str;
          description = "Password used for all administration functions.";
        };
      };

      logDir = mkOption {
        type = types.path;
        description = "Base directory used for logging.";
        default = "/var/log/icecast";
      };

      listen = {
        port = mkOption {
          type = types.port;
          description = "TCP port that will be used to accept client connections.";
          default = 8000;
        };

        address = mkOption {
          type = types.str;
          description = "Address Icecast will listen on.";
          default = "::";
        };
      };

      user = mkOption {
        type = types.str;
        description = "User privileges for the server.";
        default = "nobody";
      };

      group = mkOption {
        type = types.str;
        description = "Group privileges for the server.";
        default = "nogroup";
      };

      extraConf = mkOption {
        type = types.lines;
        description = "icecast.xml content.";
        default = "";
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.icecast = {
      after = [ "network.target" ];
      description = "Icecast Network Audio Streaming Server";
      wantedBy = [ "multi-user.target" ];

      preStart = "mkdir -p ${cfg.logDir} && chown ${cfg.user}:${cfg.group} ${cfg.logDir}";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.icecast}/bin/icecast -c ${configFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };

  };

}
