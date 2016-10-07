{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.privacyidea;

  piCfgFile = pkgs.writeText "privacyidea.cfg" ''
    SUPERUSER_REALM = [ '${concatStringsSep "', '" cfg.superuserRealm}' ]
    SQLALCHEMY_DATABASE_URI = '${cfg.databaseURI}'
    SECRET_KEY = '${cfg.secretKey}'
    PI_PEPPER = '${cfg.pepper}'
    PI_ENCFILE = '${cfg.encFile}'
    PI_AUDIT_KEY_PRIVATE = '${cfg.auditKeyPrivate}'
    PI_AUDIT_KEY_PUBLIC = '${cfg.auditKeyPublic}'
    PI_LOGLEVEL = 20
    ${cfg.extraConfig}
  '';

in

{
  options = {
    services.privacyidea = {
      enable = mkEnableOption "PrivacyIDEA";

      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/privacyidea";
        description = ''
          Directory where all PrivacyIDEA files will be placed by default.
        '';
      };

      runDir = mkOption {
        type = types.str;
        default = "/run/privacyidea";
        description = ''
          Directory where all PrivacyIDEA files will be placed by default.
        '';
      };

      superuserRealm = mkOption {
        type = types.listOf types.str;
        default = [ "super" "administrators" ];
        description = ''
          The realm where users are allowed to login as administrators.
        '';
      };

      databaseURI = mkOption {
        type = types.str;
        default = "postgresql://privacyidea:privacyidea@localhost/privacyidea";
        description = ''
          Database as SQLAlchemy URI to use for PrivacyIDEA.
        '';
      };

      secretKey = mkOption {
        type = types.str;
        example = "t0p s3cr3t";
        description = ''
          This is used to encrypt the auth_token.
        '';
      };

      pepper = mkOption {
        type = types.str;
        example = "Never know...";
        description = ''
          This is used to encrypt the admin passwords.
        '';
      };

      encFile = mkOption {
        type = types.str;
        default = "${cfg.stateDir}/enckey";
        description = ''
          This is used to encrypt the token data and token passwords
        '';
      };

      auditKeyPrivate = mkOption {
        type = types.str;
        default = "${cfg.stateDir}/private.pem";
        description = ''
          Private Key for signing the audit log.
        '';
      };

      auditKeyPublic = mkOption {
        type = types.str;
        default = "${cfg.stateDir}/public.pem";
        description = ''
          Public key for checking signatures of the audit log.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration options for pi.cfg.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "privacyidea";
        description = "User account under which PrivacyIDEA runs.";
      };

      group = mkOption {
        type = types.str;
        default = "privacyidea";
        description = "Group account under which PrivacyIDEA runs.";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.privacyidea ];

    systemd.services.privacyidea = let
        uwsgi = pkgs.uwsgi.override { plugins = [ "python2" ]; };
        penv = uwsgi.python2.buildEnv.override {
          extraLibs = [ pkgs.privacyidea ];
        };
        piuwsgi = pkgs.writeText "uwsgi.json" (builtins.toJSON {
          uwsgi = {
            plugins = [ "python2" ];
            pythonpath = "${penv}/${uwsgi.python2.sitePackages}";
            socket = "${cfg.runDir}/socket";
            chmod-socket = 770;
            chown-socket = "${cfg.user}:nginx";
            chdir = cfg.stateDir;
            wsgi-file = "${pkgs.privacyidea}/etc/privacyidea/privacyideaapp.wsgi";
            processes = 4;
            harakiri = 60;
            reload-mercy = 8;
            stats = "${cfg.runDir}/stats.socket";
            max-requests = 2000;
            limit-as = 512;
            reload-on-as = 256;
            reload-on-rss = 192;
            no-orphans = true;
            vacuum = true;
            pyargv = piCfgFile;
          };
        }); in {
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p ${cfg.stateDir} ${cfg.runDir}
        chown ${cfg.user}:${cfg.group} -R ${cfg.stateDir} ${cfg.runDir}
      '';
      serviceConfig = {
        Type = "notify";
        ExecStart = "${uwsgi}/bin/uwsgi --uid ${cfg.user} --gid ${cfg.group} --json ${piuwsgi}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStop = "${pkgs.coreutils}/bin/kill -INT $MAINPID";
        NotifyAccess = "main";
        KillSignal = "SIGQUIT";
      };
    };

    users.extraUsers = optionalAttrs (cfg.user == "privacyidea") (singleton
      { name = cfg.user;
        group = cfg.group;
        uid = config.ids.uids.uwsgi;
      });

    users.extraGroups = optionalAttrs (cfg.group == "privacyidea") (singleton
      { name = cfg.group;
        gid = config.ids.gids.uwsgi;
      });

  };

}

