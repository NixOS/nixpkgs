{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.ihatemoney;
  user = "ihatemoney";
  group = "ihatemoney";
  db = "ihatemoney";
  python3 = config.services.uwsgi.package.python3;
  pkg = python3.pkgs.ihatemoney;
  toBool = x: if x then "True" else "False";
  configFile = pkgs.writeText "ihatemoney.cfg" ''
        from secrets import token_hex
        # load a persistent secret key
        SECRET_KEY_FILE = "/var/lib/ihatemoney/secret_key"
        SECRET_KEY = ""
        try:
          with open(SECRET_KEY_FILE) as f:
            SECRET_KEY = f.read()
        except FileNotFoundError:
          pass
        if not SECRET_KEY:
          print("ihatemoney: generating a new secret key")
          SECRET_KEY = token_hex(50)
          with open(SECRET_KEY_FILE, "w") as f:
            f.write(SECRET_KEY)
        del token_hex
        del SECRET_KEY_FILE

        # "normal" configuration
        DEBUG = False
        SQLALCHEMY_DATABASE_URI = '${
          if cfg.backend == "sqlite"
          then "sqlite:////var/lib/ihatemoney/ihatemoney.sqlite"
          else "postgresql:///${db}"}'
        SQLALCHEMY_TRACK_MODIFICATIONS = False
        MAIL_DEFAULT_SENDER = (r"${cfg.defaultSender.name}", r"${cfg.defaultSender.email}")
        ACTIVATE_DEMO_PROJECT = ${toBool cfg.enableDemoProject}
        ADMIN_PASSWORD = r"${toString cfg.adminHashedPassword /*toString null == ""*/}"
        ALLOW_PUBLIC_PROJECT_CREATION = ${toBool cfg.enablePublicProjectCreation}
        ACTIVATE_ADMIN_DASHBOARD = ${toBool cfg.enableAdminDashboard}
        SESSION_COOKIE_SECURE = ${toBool cfg.secureCookie}
        ENABLE_CAPTCHA = ${toBool cfg.enableCaptcha}
        LEGAL_LINK = r"${toString cfg.legalLink}"

        ${cfg.extraConfig}
  '';
in
  {
    options.services.ihatemoney = {
      enable = mkEnableOption (lib.mdDoc "ihatemoney webapp. Note that this will set uwsgi to emperor mode");
      backend = mkOption {
        type = types.enum [ "sqlite" "postgresql" ];
        default = "sqlite";
        description = lib.mdDoc ''
          The database engine to use for ihatemoney.
          If `postgresql` is selected, then a database called
          `${db}` will be created. If you disable this option,
          it will however not be removed.
        '';
      };
      adminHashedPassword = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc "The hashed password of the administrator. To obtain it, run `ihatemoney generate_password_hash`";
      };
      uwsgiConfig = mkOption {
        type = types.attrs;
        example = {
          http = ":8000";
        };
        description = lib.mdDoc "Additional configuration of the UWSGI vassal running ihatemoney. It should notably specify on which interfaces and ports the vassal should listen.";
      };
      defaultSender = {
        name = mkOption {
          type = types.str;
          default = "Budget manager";
          description = lib.mdDoc "The display name of the sender of ihatemoney emails";
        };
        email = mkOption {
          type = types.str;
          default = "ihatemoney@${config.networking.hostName}";
          defaultText = literalExpression ''"ihatemoney@''${config.networking.hostName}"'';
          description = lib.mdDoc "The email of the sender of ihatemoney emails";
        };
      };
      secureCookie = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Use secure cookies. Disable this when ihatemoney is served via http instead of https";
      };
      enableDemoProject = mkEnableOption (lib.mdDoc "access to the demo project in ihatemoney");
      enablePublicProjectCreation = mkEnableOption (lib.mdDoc "permission to create projects in ihatemoney by anyone");
      enableAdminDashboard = mkEnableOption (lib.mdDoc "ihatemoney admin dashboard");
      enableCaptcha = mkEnableOption (lib.mdDoc "a simplistic captcha for some forms");
      legalLink = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc "The URL to a page explaining legal statements about your service, eg. GDPR-related information.";
      };
      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc "Extra configuration appended to ihatemoney's configuration file. It is a python file, so pay attention to indentation.";
      };
    };
    config = mkIf cfg.enable {
      services.postgresql = mkIf (cfg.backend == "postgresql") {
        enable = true;
        ensureDatabases = [ db ];
        ensureUsers = [ {
          name = user;
          ensurePermissions = {
            "DATABASE ${db}" = "ALL PRIVILEGES";
          };
        } ];
      };
      systemd.services.postgresql = mkIf (cfg.backend == "postgresql") {
        wantedBy = [ "uwsgi.service" ];
        before = [ "uwsgi.service" ];
      };
      systemd.tmpfiles.rules = [
        "d /var/lib/ihatemoney 770 ${user} ${group}"
      ];
      users = {
        users.${user} = {
          isSystemUser = true;
          inherit group;
        };
        groups.${group} = {};
      };
      services.uwsgi = {
        enable = true;
        plugins = [ "python3" ];
        instance = {
          type = "emperor";
          vassals.ihatemoney = {
            type = "normal";
            strict = true;
            immediate-uid = user;
            immediate-gid = group;
            # apparently flask uses threads: https://github.com/spiral-project/ihatemoney/commit/c7815e48781b6d3a457eaff1808d179402558f8c
            enable-threads = true;
            module = "wsgi:application";
            chdir = "${pkg}/${pkg.pythonModule.sitePackages}/ihatemoney";
            env = [ "IHATEMONEY_SETTINGS_FILE_PATH=${configFile}" ];
            pythonPackages = self: [ self.ihatemoney ];
          } // cfg.uwsgiConfig;
        };
      };
    };
  }


