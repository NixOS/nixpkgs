{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.staytus;

  bundler = pkgs.bundler;
  package = pkgs.staytus;
  ruby = package.ruby;

  databaseYml = ''
    production:
      adapter: mysql2
      pool: 5
      database: ${cfg.databaseName}
      host: ${cfg.databaseHost}
      password: ${cfg.databasePassword}
      username: ${cfg.username}
      encoding: utf8
  '';

  configurationYml = ''
    default:

      ${cfg.extraConfig}
  '';

  procfileOptions = ''
app_name: staytus
processes:
  web:
    restart_mode: usr2
  worker:
    restart_mode: start-term
log_path: ${runDir}/log/staytus.log
log_root: ${runDir}/log
pid_root: ${runDir}/pids
env:
${concatStrings (mapAttrsToList (name: value: "  ${name}: ${value}\n") staytusEnv)}
'';

 procfile = ''
web: ${staytus-rake}/bin/staytus-puma
worker: ${staytus-rake}/bin/staytus-jobs
  '';

  unpackTheme = unpack "theme";
  unpack = id: (name: source:
    pkgs.stdenv.mkDerivation {
      name = "staytus-${id}-${name}";
      buildInputs = [ pkgs.unzip ];
      buildCommand = ''
        mkdir -p $out
        cd $out
        unpackFile ${source}
      '';
  });

  staytusEnv = {
    RAILS_ENV = "production";
    RACK_ENV = "production";
    SECRET_KEY_BASE = cfg.secretKeyBase;
    RAILS_LOG = "${runDir}/log";
    HOME = "${runDir}";
    STAYTUS_LANG = "en";
    STAYTUS_THEME = "${cfg.theme}";
    STAYTUS_DEMO = "0";
    STAYTUS_SMTP_HOSTNAME = "${cfg.smtpHost}";
    STAYTUS_SMTP_PORT = "${cfg.smtpPort}";
    STAYTUS_SMTP_USERNAME = "${cfg.smtpUsername}";
    STAYTUS_SMTP_PASSWORD = "${cfg.smtpPassword}";
    GEM_HOME = "${package}/${ruby.gemPath}";
    PUMA_DEBUG = if cfg.pumaDebug then "1" else "0";
    RAILS_LOG_TO_STDOUT = "1";
    APP_ROOT = "${runDir}";
  };

  runDir = "/var/run/staytus";

  staytus-rake = pkgs.stdenv.mkDerivation rec {
    name = "staytus-rake";
    buildInputs = [ package.env pkgs.makeWrapper ];
    phases = "installPhase fixupPhase";
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${package.env}/bin/bundle $out/bin/staytus-bundle \
          ${concatStrings (mapAttrsToList (name: value: "--set ${name} '${value}' ") staytusEnv)} \
          --set PATH '${lib.makeBinPath (with pkgs; [ nodejs ])}:$PATH' \
          --set RAKEOPT '-f ${runDir}/Rakefile' \
          --run 'cd ${runDir}'
      makeWrapper $out/bin/staytus-bundle $out/bin/staytus-rake \
          --add-flags "exec rake"
      makeWrapper $out/bin/staytus-rake $out/bin/staytus-jobs \
          --add-flags "jobs:work"
      makeWrapper $out/bin/staytus-bundle $out/bin/staytus-puma \
          --add-flags "exec puma" \
          --add-flags "--environment production" \
          --add-flags "-C ${runDir}/config/puma.rb" \
          --add-flags "--redirect-stdout ${cfg.stateDir}/log/puma.log" \
          --add-flags "--redirect-stderr ${cfg.stateDir}/log/puma.error.log" \
          --add-flags "--redirect-append" \
          --add-flags "--pidfile ${runDir}/pids/puma.pid"
     '';
  };

in {

  options = {
    services.staytus = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the staytus service.
        '';
      };

      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/staytus";
        description = "The state directory, logs are stored here";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra configuration in configuration.yml";
      };

      themes = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = ''
          Set of themes

          For example, to add and set a custom theme named "awesomecompany":
          services.staytus = {
            themes = {
              awesomecompany = ./path/to/private/theme.zip;
            };
            theme = "awesomecompany";
          };
        '';
      };

      theme = mkOption {
        type = types.str;
        default = "default";
        description = "The theme to activate";
      };

      databaseHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Database hostname";
      };

      databasePassword = mkOption {
        type = types.str;
        default = "";
        description = "Database user password";
      };

      databaseName = mkOption {
        type = types.str;
        default = "staytus";
        description = "Database name";
      };

      username = mkOption {
        type = types.str;
        default = "staytus";
        description = "user the service will run as, and database user";
      };

      group = mkOption {
        type = types.str;
        default = "staytus";
        description = "group the service will run as";
      };

      smtpHost = mkOption {
        type = types.str;
        default = "smtp.deliverhq.com";
        description = "SMTP hostname";
      };

      smtpPort = mkOption {
        type = types.str;
        default = "25";
        description = "SMTP port";
      };

      smtpPassword = mkOption {
        type = types.str;
        default = "";
        description = "SMTP user password";
      };

      smtpUsername = mkOption {
        type = types.str;
        default = "";
        description = "SMTP user name";
      };

      secretKeyBase = mkOption {
        type = types.str;
        default = "";
        description = "Secret key base";
      };

      vhosts = mkOption {
        type = types.listOf types.str;
        default = [ "${config.networking.hostName}" ];
        example = [ "status.yourservice.org" ];
        description = ''
          A list of virtual hosts. They must be given as exact names if acme is enabled.
        '';
      };

      pumaDebug = mkOption {
        type = types.bool;
        default = false;
        description = "Activate puma debug mode";
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.databasePassword != "";
        message = "services.staytus.databasePassword must be set";
      }
    ];

    users.extraUsers = [
      { name = cfg.username;
        group = cfg.group;
        home = cfg.stateDir;
      } ];

    users.extraGroups = [
      { name = cfg.group;
      } ];

    services.mysql = mkIf (cfg.databaseHost == "127.0.0.1") {
      ensureDatabases = [ cfg.databaseName ];
      ensureUsers = [{
        name = cfg.username;
        ensurePermissions = { "${cfg.databaseName}.*" = "ALL PRIVILEGES"; };
      }];
    };

    system.activationScripts = {
      staytus = {
        text = ''
          mkdir -p ${cfg.stateDir}
          mkdir -p ${runDir}
        '';
        deps = [];
      };
    };

    systemd.services.staytusjobs = {
      after = [ "network.target" "mysql.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = staytusEnv;

      path = with pkgs; [
        config.services.mysql.package
      ];
      preStart = ''
        rm -rf ${runDir}/*
        mkdir -p ${runDir}/pids

        cp -Rv ${package}/share/staytus/* ${runDir}

        mkdir -p ${cfg.stateDir}/log
        rm -rf ${runDir}/log
        ln -sf ${cfg.stateDir}/log ${runDir}/log

        chown -R ${cfg.username}:${cfg.group} ${cfg.stateDir}
        chmod -R 755 ${cfg.stateDir}

        echo "Symlinking generated configs"
        echo "ln -sf ${pkgs.writeText "database.yml" databaseYml} ${runDir}/database.yml"
        ln -sf ${pkgs.writeText "database.yml" databaseYml} ${runDir}/config/database.yml
        ln -sf ${pkgs.writeText "Procfile" procfile} ${runDir}/Procfile
        ln -sf ${pkgs.writeText "Procfile.local" procfileOptions} ${runDir}/Procfile.options

        if [ "${cfg.databaseHost}" = "127.0.0.1" ]; then
          if ! test -e "${cfg.stateDir}/user-granted"; then

            echo "Adding user to database"
            ${pkgs.mysql}/bin/mysql -e "GRANT ALL ON ${cfg.databaseName}.* TO ${cfg.username}@localhost IDENTIFIED BY \"${cfg.databasePassword}\";"

            touch "${cfg.stateDir}/user-granted"
            chown ${cfg.username}:${cfg.group} "${cfg.stateDir}/user-granted"
          fi
        fi

        echo "Copying themes"
        for theme in ${concatStringsSep " " (mapAttrsToList unpackTheme cfg.themes)}; do
          ln -fs $theme/* ${runDir}/content/themes/
        done

        chown -R ${cfg.username}:${cfg.group} ${runDir}
        chmod -R 755 ${runDir}

        echo "Preparing database and files"
        if ! test -e "${cfg.stateDir}/staytus-installed"; then
          ${staytus-rake}/bin/staytus-rake staytus:build staytus:install
          touch "${cfg.stateDir}/staytus-installed"
          chown ${cfg.username}:${cfg.group} "${cfg.stateDir}/staytus-installed"
        else
          ${staytus-rake}/bin/staytus-rake staytus:build staytus:upgrade
        fi

      '';

      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        Type = "simple";
        User = "staytus";
        Group = "staytus";
        TimeoutSec = "300";
        WorkingDirectory = "${runDir}";
        ExecStart="${staytus-rake}/bin/staytus-jobs";
      };
    };

    systemd.services.staytus = {
      after = [ "staytusjobs.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = staytusEnv;

      path = with pkgs; [
        config.services.mysql.package
      ];

      serviceConfig = {
        Type = "simple";
        User = "staytus";
        Group = "staytus";
        TimeoutSec = "300";
        WorkingDirectory = "${runDir}";
        ExecStart="${staytus-rake}/bin/staytus-puma";
      };
    };


    services.nginx = {
      virtualHosts = {
        "${builtins.head cfg.vhosts}" = {
          forceSSL = true;
          enableACME = true;
          root = "${runDir}";
          serverAliases = builtins.tail cfg.vhosts;

          extraConfig = ''
            location /assets {
              root ${runDir}/public/;
              add_header Cache-Control max-age=3600;
            }

            location / {
              try_files $uri $uri/index.html $uri.html @puma;
            }

            location @puma {
              proxy_intercept_errors on;
              proxy_set_header X-Real-IP  $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto http;
              proxy_set_header Host $http_host;
              proxy_redirect off;
              proxy_pass http://127.0.0.1:8787;
            }

          '';
          };
      };
    };

  };

}
