{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.privacyidea;

  uwsgi = pkgs.uwsgi.override { plugins = [ "python3" ]; };
  python = uwsgi.python3;
  penv = python.withPackages (const [ pkgs.privacyidea ]);
  logCfg = pkgs.writeText "privacyidea-log.cfg" ''
    [formatters]
    keys=detail

    [handlers]
    keys=stream

    [formatter_detail]
    class=privacyidea.lib.log.SecureFormatter
    format=[%(asctime)s][%(process)d][%(thread)d][%(levelname)s][%(name)s:%(lineno)d] %(message)s

    [handler_stream]
    class=StreamHandler
    level=NOTSET
    formatter=detail
    args=(sys.stdout,)

    [loggers]
    keys=root,privacyidea

    [logger_privacyidea]
    handlers=stream
    qualname=privacyidea
    level=INFO

    [logger_root]
    handlers=stream
    level=ERROR
  '';

  piCfgFile = pkgs.writeText "privacyidea.cfg" ''
    SUPERUSER_REALM = [ '${concatStringsSep "', '" cfg.superuserRealm}' ]
    SQLALCHEMY_DATABASE_URI = 'postgresql:///privacyidea'
    SECRET_KEY = '${cfg.secretKey}'
    PI_PEPPER = '${cfg.pepper}'
    PI_ENCFILE = '${cfg.encFile}'
    PI_AUDIT_KEY_PRIVATE = '${cfg.auditKeyPrivate}'
    PI_AUDIT_KEY_PUBLIC = '${cfg.auditKeyPublic}'
    PI_LOGCONFIG = '${logCfg}'
    ${cfg.extraConfig}
  '';

in

{
  options = {
    services.privacyidea = {
      enable = mkEnableOption "PrivacyIDEA";

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/root/privacyidea.env";
        description = ''
          File to load as environment file. Environment variables
          from this file will be interpolated into the config file
          using <package>envsubst</package> which is helpful for specifying
          secrets:
          <programlisting>
          { <xref linkend="opt-services.privacyidea.secretKey" /> = "$SECRET"; }
          </programlisting>

          The environment-file can now specify the actual secret key:
          <programlisting>
          SECRET=veryverytopsecret
          </programlisting>
        '';
      };

      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/privacyidea";
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

      adminPasswordFile = mkOption {
        type = types.path;
        description = "File containing password for the admin user";
      };

      adminEmail = mkOption {
        type = types.str;
        example = "admin@example.com";
        description = "Mail address for the admin user";
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

      ldap-proxy = {
        enable = mkEnableOption "PrivacyIDEA LDAP Proxy";

        configFile = mkOption {
          type = types.path;
          description = ''
            Path to PrivacyIDEA LDAP Proxy configuration (proxy.ini).
          '';
        };

        user = mkOption {
          type = types.str;
          default = "pi-ldap-proxy";
          description = "User account under which PrivacyIDEA LDAP proxy runs.";
        };

        group = mkOption {
          type = types.str;
          default = "pi-ldap-proxy";
          description = "Group account under which PrivacyIDEA LDAP proxy runs.";
        };
      };
    };
  };

  config = mkMerge [

    (mkIf cfg.enable {

      environment.systemPackages = [ pkgs.privacyidea ];

      services.postgresql.enable = mkDefault true;

      systemd.services.privacyidea = let
        piuwsgi = pkgs.writeText "uwsgi.json" (builtins.toJSON {
          uwsgi = {
            plugins = [ "python3" ];
            pythonpath = "${penv}/${uwsgi.python3.sitePackages}";
            socket = "/run/privacyidea/socket";
            uid = cfg.user;
            gid = cfg.group;
            chmod-socket = 770;
            chown-socket = "${cfg.user}:nginx";
            chdir = cfg.stateDir;
            wsgi-file = "${penv}/etc/privacyidea/privacyideaapp.wsgi";
            processes = 4;
            harakiri = 60;
            reload-mercy = 8;
            stats = "/run/privacyidea/stats.socket";
            max-requests = 2000;
            limit-as = 1024;
            reload-on-as = 512;
            reload-on-rss = 256;
            no-orphans = true;
            vacuum = true;
          };
        });
      in {
        wantedBy = [ "multi-user.target" ];
        after = [ "postgresql.service" ];
        path = with pkgs; [ openssl ];
        environment.PRIVACYIDEA_CONFIGFILE = "${cfg.stateDir}/privacyidea.cfg";
        preStart = let
          pi-manage = "${config.security.sudo.package}/bin/sudo -u privacyidea -HE ${penv}/bin/pi-manage";
          pgsu = config.services.postgresql.superUser;
          psql = config.services.postgresql.package;
        in ''
          mkdir -p ${cfg.stateDir} /run/privacyidea
          chown ${cfg.user}:${cfg.group} -R ${cfg.stateDir} /run/privacyidea
          umask 077
          ${lib.getBin pkgs.envsubst}/bin/envsubst -o ${cfg.stateDir}/privacyidea.cfg \
                                                   -i "${piCfgFile}"
          chown ${cfg.user}:${cfg.group} ${cfg.stateDir}/privacyidea.cfg
          if ! test -e "${cfg.stateDir}/db-created"; then
            ${config.security.sudo.package}/bin/sudo -u ${pgsu} ${psql}/bin/createuser --no-superuser --no-createdb --no-createrole ${cfg.user}
            ${config.security.sudo.package}/bin/sudo -u ${pgsu} ${psql}/bin/createdb --owner ${cfg.user} privacyidea
            ${pi-manage} create_enckey
            ${pi-manage} create_audit_keys
            ${pi-manage} createdb
            ${pi-manage} admin add admin -e ${cfg.adminEmail} -p "$(cat ${cfg.adminPasswordFile})"
            ${pi-manage} db stamp head -d ${penv}/lib/privacyidea/migrations
            touch "${cfg.stateDir}/db-created"
            chmod g+r "${cfg.stateDir}/enckey" "${cfg.stateDir}/private.pem"
          fi
          ${pi-manage} db upgrade -d ${penv}/lib/privacyidea/migrations
        '';
        serviceConfig = {
          Type = "notify";
          ExecStart = "${uwsgi}/bin/uwsgi --json ${piuwsgi}";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
          ExecStop = "${pkgs.coreutils}/bin/kill -INT $MAINPID";
          NotifyAccess = "main";
          KillSignal = "SIGQUIT";
        };
      };

      users.users.privacyidea = mkIf (cfg.user == "privacyidea") {
        group = cfg.group;
        isSystemUser = true;
      };

      users.groups.privacyidea = mkIf (cfg.group == "privacyidea") {};
    })

    (mkIf cfg.ldap-proxy.enable {

      systemd.services.privacyidea-ldap-proxy = let
        ldap-proxy-env = pkgs.python3.withPackages (ps: [ ps.privacyidea-ldap-proxy ]);
      in {
        description = "privacyIDEA LDAP proxy";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = cfg.ldap-proxy.user;
          Group = cfg.ldap-proxy.group;
          ExecStart = ''
            ${ldap-proxy-env}/bin/twistd \
              --nodaemon \
              --pidfile= \
              -u ${cfg.ldap-proxy.user} \
              -g ${cfg.ldap-proxy.group} \
              ldap-proxy \
              -c ${cfg.ldap-proxy.configFile}
          '';
          Restart = "always";
        };
      };

      users.users.pi-ldap-proxy = mkIf (cfg.ldap-proxy.user == "pi-ldap-proxy") {
        group = cfg.ldap-proxy.group;
        isSystemUser = true;
      };

      users.groups.pi-ldap-proxy = mkIf (cfg.ldap-proxy.group == "pi-ldap-proxy") {};
    })
  ];

}
