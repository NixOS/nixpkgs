{
  config,
  lib,
  options,
  pkgs,
  ...
}:

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

      enable = lib.mkEnableOption "the Quassel IRC client daemon";

      certificateFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Path to the certificate used for SSL connections with clients.
        '';
      };

      requireSSL = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Require SSL for connections from clients.
        '';
      };

      package = lib.mkPackageOption pkgs "quasselDaemon" { };

      interfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "127.0.0.1" ];
        description = ''
          The interfaces the Quassel daemon will be listening to.  If `[ 127.0.0.1 ]`,
          only clients on the local host can connect to it; if `[ 0.0.0.0 ]`, clients
          can access it from any network interface.
        '';
      };

      portNumber = lib.mkOption {
        type = lib.types.port;
        default = 4242;
        description = ''
          The port number the Quassel daemon will be listening to.
        '';
      };

      dataDir = lib.mkOption {
        default = "/home/${user}/.config/quassel-irc.org";
        defaultText = lib.literalExpression ''
          "/home/''${config.${opt.user}}/.config/quassel-irc.org"
        '';
        type = lib.types.str;
        description = ''
          The directory holding configuration files, the SQlite database and the SSL Cert.
        '';
      };

      user = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = ''
          The existing user the Quassel daemon should run as. If left empty, a default "quassel" user will be created.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.requireSSL -> cfg.certificateFile != null;
        message = "Quassel needs a certificate file in order to require SSL";
      }
    ];

    users.users = lib.optionalAttrs (cfg.user == null) {
      quassel = {
        name = "quassel";
        description = "Quassel IRC client daemon";
        group = "quassel";
        uid = config.ids.uids.quassel;
      };
    };

    users.groups = lib.optionalAttrs (cfg.user == null) {
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
        ++ lib.optional config.services.postgresql.enable "postgresql.service"
        ++ lib.optional config.services.mysql.enable "mysql.service";

      serviceConfig = {
        ExecStart = lib.concatStringsSep " " (
          [
            "${quassel}/bin/quasselcore"
            "--listen=${lib.concatStringsSep "," cfg.interfaces}"
            "--port=${toString cfg.portNumber}"
            "--configdir=${cfg.dataDir}"
          ]
          ++ lib.optional cfg.requireSSL "--require-ssl"
          ++ lib.optional (cfg.certificateFile != null) "--ssl-cert=${cfg.certificateFile}"
        );
        User = user;
      };
    };

  };

}
