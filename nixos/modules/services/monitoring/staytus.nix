{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.staytus;

  bundler = pkgs.bundler;
  procodile = pkgs.procodile;
  package = pkgs.staytus;
  ruby = package.ruby;

  databaseYml = ''
    production:
      adapter: mysql2
      pool: 5
      database: ${cfg.databaseName}
      host: ${cfg.databaseHost}
      password: ${cfg.databasePassword}
      username: ${cfg.databaseUsername}
      encoding: utf8
  '';

  configurationYml = ''
    default:

      ${cfg.extraConfig}
  '';

  procfileLocal = ''
log_path: /run/staytus/log/procodile.log
log_root: /run/staytus/log
pid_root: /run/staytus/pids
web: ${staytus-rake}/bin/staytus-puma
worker: ${staytus-rake}/bin/staytus-jobs
env:
${concatStrings (mapAttrsToList (name: value: "  ${name}: ${value}\n") staytusEnv)}
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
    RAILS_ETC = "${cfg.stateDir}/config";
    RAILS_LOG = "${cfg.stateDir}/log";
    RAILS_PUBLIC = "${cfg.stateDir}/public";
    RAILS_TMP = "${cfg.stateDir}/tmp";
    HOME = "${package}";
    STAYTUS_LANG = "en";
    STAYTUS_THEME = "${cfg.theme}";
    STAYTUS_DEMO = "0";
    STAYTUS_SMTP_HOSTNAME = "${cfg.smtpHost}";
    STAYTUS_SMTP_PORT = "${cfg.smtpPort}";
    STAYTUS_SMTP_USERNAME = "${cfg.smtpUsername}";
    STAYTUS_SMTP_PASSWORD = "${cfg.smtpPassword}";
    GEM_HOME = "${package}/${ruby.gemPath}";
  };

  staytus-rake = pkgs.stdenv.mkDerivation rec {
    name = "staytus-rake";
    buildInputs = [ package.env pkgs.makeWrapper ];
    phases = "installPhase fixupPhase";
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${package.env}/bin/bundle $out/bin/staytus-bundle \
          ${concatStrings (mapAttrsToList (name: value: "--set ${name} '${value}' ") staytusEnv)} \
          --set PATH '${lib.makeBinPath (with pkgs; [ nodejs ])}:$PATH' \
          --set RAKEOPT '-f ${package}/share/staytus/Rakefile' \
          --run 'cd ${cfg.stateDir}'
      makeWrapper $out/bin/staytus-bundle $out/bin/staytus-rake \
          --add-flags "exec rake"
      makeWrapper $out/bin/staytus-rake $out/bin/staytus-jobs \
          --add-flags "jobs:work"
      makeWrapper $out/bin/staytus-bundle $out/bin/staytus-rails \
          --add-flags "exec rails"
      makeWrapper $out/bin/staytus-bundle $out/bin/staytus-puma \
          --add-flags "exec puma" \
          --add-flags "-C ${package}/share/staytus/config/puma.rb"
      makeWrapper ${procodile}/bin/procodile $out/bin/staytus-procodile-start \
          ${concatStrings (mapAttrsToList (name: value: "--set ${name} '${value}' ") staytusEnv)} \
          --add-flags "start" \
          --add-flags "--clean" \
          --add-flags "--root ${package}/share/staytus/" \
          --add-flags "--procfile /run/staytus/Procfile" \
          --run 'cd ${cfg.stateDir}'
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
        default = "/var/staytus";
        description = "The state directory, logs and plugins are stored here";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra configuration in configuration.yml";
      };

      themes = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = "Set of themes";
      };

      theme = mkOption {
        type = types.str;
        default = "default";
        description = "The theme to activate";
      };

      #databaseType = mkOption {
      #  type = types.str;
      #  default = "postgresql";
      #  description = "Type of database";
      #};

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

      databaseUsername = mkOption {
        type = types.str;
        default = "staytus";
        description = "Database user";
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
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.databasePassword != "";
        message = "services.staytus.databasePassword must be set";
      }
    ];

    users.extraUsers = [
      { name = "staytus";
        group = "staytus";
        home = cfg.stateDir;
      } ];

    users.extraGroups = [
      { name = "staytus";
      } ];

    systemd.services.staytus = {
      after = [ "network.target" "mysql.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = staytusEnv;

      path = with pkgs; [
        config.services.mysql.package
      ];
      preStart = ''
        export HOME=$TMP
        chown -R staytus:staytus ${cfg.stateDir}
        chmod -R 755 ${cfg.stateDir}

        mkdir /run/staytus/{log,pids} -p

#        for theme in ${concatStringsSep " " (mapAttrsToList unpackTheme cfg.themes)}; do
#          ln -fs $theme/* ${package}/content/themes/
#        done

        echo "Symlinking generated configs"
        echo "ln -sf ${pkgs.writeText "database.yml" databaseYml} /run/staytus/database.yml"
        ln -sf ${pkgs.writeText "database.yml" databaseYml} /run/staytus/database.yml
        echo "ln -sf ${pkgs.writeText "configuration.yml" configurationYml}  /run/staytus/configuration.yml"
        ln -sf ${pkgs.writeText "configuration.yml" configurationYml} /run/staytus/configuration.yml
        ln -sf ${package}/share/staytus/Procfile /run/staytus/Procfile
        ln -sf ${package}/share/staytus/Procfile.options /run/staytus/Procfile.options
        ln -sf ${pkgs.writeText "Procfile.local" procfileLocal} /run/staytus/Procfile.local

        ln -sf ${cfg.stateDir}/system /run/staytus/system

        if [ "${cfg.databaseHost}" = "127.0.0.1" ]; then
          if ! test -e "${cfg.stateDir}/db-created"; then
            # echo "Need to create the database '${cfg.databaseName}' and grant permissions to user named '${cfg.databaseUsername}'."
            # Wait until MySQL is up
            #   sleep 1
            # done

            ${pkgs.mysql}/bin/mysql -e 'CREATE DATABASE ${cfg.databaseName};'
            ${pkgs.mysql}/bin/mysql -e "GRANT ALL ON ${cfg.databaseName}.* TO ${cfg.databaseUsername}@localhost IDENTIFIED BY \"${cfg.databasePassword}\";"


            touch "${cfg.stateDir}/db-created"
          fi
        fi

        if test -e "${cfg.stateDir}/db-drop"; then
          echo "Reseting database"
          ${staytus-rake}/bin/staytus-rake db:environment:set db:reset DISABLE_DATABASE_ENVIRONMENT_CHECK=1
          rm -f "${cfg.stateDir}/db-drop"
        fi

        ${staytus-rake}/bin/staytus-rake db:migrate

        chown -R staytus:staytus /run/staytus

      '';

      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        Type = "simple";
        User = "staytus";
        Group = "staytus";
        TimeoutSec = "300";
        WorkingDirectory = "${package}/share/staytus";
        ExecStart="${staytus-rake}/bin/staytus-procodile-start";
      };

    };

    services.nginx = {
      virtualHosts = {
        "${builtins.head cfg.vhosts}" = {
          forceSSL = true;
          enableACME = true;
          root = cfg.stateDir;
          serverAliases = builtins.tail cfg.vhosts;

          extraConfig = ''
            location /assets {
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
