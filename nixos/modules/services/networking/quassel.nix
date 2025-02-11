{
  config,
  lib,
  options,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.quassel;
  opt = options.services.quassel;
  quassel = cfg.package;
  user = if cfg.user != null then cfg.user else "quassel";
in

{

  ###### interface

  options = {

    services.quassel = {

      enable = mkEnableOption "the Quassel IRC client daemon";

      certificateFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Path to the certificate used for SSL connections with clients.
        '';
      };

      requireSSL = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Require SSL for connections from clients.
        '';
      };

      package = mkPackageOption pkgs "quasselDaemon" { };

      interfaces = mkOption {
        type = types.listOf types.str;
        default = [ "127.0.0.1" ];
        description = ''
          The interfaces the Quassel daemon will be listening to.  If `[ 127.0.0.1 ]`,
          only clients on the local host can connect to it; if `[ 0.0.0.0 ]`, clients
          can access it from any network interface.
        '';
      };

      portNumber = mkOption {
        type = types.port;
        default = 4242;
        description = ''
          The port number the Quassel daemon will be listening to.
        '';
      };

      dataDir = mkOption {
        default = "/home/${user}/.config/quassel-irc.org";
        defaultText = literalExpression ''
          "/home/''${config.${opt.user}}/.config/quassel-irc.org"
        '';
        type = types.str;
        description = ''
          The directory holding configuration files, the SQlite database and the SSL Cert.
        '';
      };

      user = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = ''
          The existing user the Quassel daemon should run as. If left empty, a default "quassel" user will be created.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.requireSSL -> cfg.certificateFile != null;
        message = "Quassel needs a certificate file in order to require SSL";
      }
    ];

    users.users = optionalAttrs (cfg.user == null) {
      quassel = {
        name = "quassel";
        description = "Quassel IRC client daemon";
        group = "quassel";
        uid = config.ids.uids.quassel;
      };
    };

    users.groups = optionalAttrs (cfg.user == null) {
      quassel = {
        name = "quassel";
        gid = config.ids.gids.quassel;
      };
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${user} - - -"
    ];

    systemd.services.quassel = {
      description = "Quassel IRC client daemon";

      wantedBy = [ "multi-user.target" ];
      after =
        [ "network.target" ]
        ++ optional config.services.postgresql.enable "postgresql.service"
        ++ optional config.services.mysql.enable "mysql.service";

      serviceConfig = {
        ExecStart = concatStringsSep " " (
          [
            "${quassel}/bin/quasselcore"
            "--listen=${concatStringsSep "," cfg.interfaces}"
            "--port=${toString cfg.portNumber}"
            "--configdir=${cfg.dataDir}"
          ]
          ++ optional cfg.requireSSL "--require-ssl"
          ++ optional (cfg.certificateFile != null) "--ssl-cert=${cfg.certificateFile}"
        );
        User = user;
      };
    };

  };

}
