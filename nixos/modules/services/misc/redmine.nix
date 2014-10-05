{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.redmine;

  ruby = pkgs.ruby;
  rubyLibs = pkgs.rubyLibs;

  # TODO: do not point to nixpkgs dir
  gemspec = map (gem: pkgs.fetchurl { url=gem.url; sha256=gem.hash; })
    (import <nixpkgs/pkgs/applications/version-management/redmine/Gemfile.nix>);

  unpackTheme = unpack "theme";
  unpackPlugin = unpack "plugin";
  unpack = id: (name: source:
    pkgs.stdenv.mkDerivation {
      name = "redmine-${id}-${name}";
      buildInputs = [ pkgs.unzip ];
      buildCommand = ''
        mkdir -p $out
        cd $out
        unpackFile ${source}
      '';
    });

  redmine = with pkgs; stdenv.mkDerivation rec {
    version = "2.5.2";
    name = "redmine-${version}";
    src = fetchurl {
      url = "http://www.redmine.org/releases/${name}.tar.gz";
      sha256 = "0x0zwxyj4dwbk7l64s3lgny10mjf0ba8jwrbafsm4d72sncmacv0";
    };
    buildInputs = [
      ruby rubyLibs.bundler libiconv libxslt libxml2 pkgconfig libffi
      imagemagickBig postgresql
    ];
    installPhase = ''
      cp -R . $out
      # TODO: /usr/share/redmine
      cd $out
      ln -s ${<nixpkgs/pkgs/applications/version-management/redmine/Gemfile.lock>} Gemfile.lock
      export HOME=$(pwd)

      mkdir -p vendor/cache

      ${concatStrings (map (gem: "ln -s ${gem} vendor/cache/${gem.name};") gemspec)}

      rm -R files log tmp
      for i in files log tmp public/plugin_assets; do
        ln -s ${cfg.stateDir}/$i $i
      done

      ln -s ${cfg.stateDir}/db/schema.rb db/schema.rb

      for theme in ${concatStringsSep " " (mapAttrsToList unpackTheme cfg.themes)}; do
        ln -s $theme/* public/themes/
      done

      for plugin in ${concatStringsSep " " (mapAttrsToList unpackPlugin cfg.plugins)}; do
        ln -s $plugin/* plugins/''${plugin##*-redmine-plugin-}
      done

      cat > config/database.yml <<EOF
      production:
        adapter: ${cfg.databaseType}
        database: ${cfg.databaseName}
        username: ${cfg.databaseUsername}
        encoding: utf8
      EOF

      ln -s ${pkgs.writeText "configuration.yml" cfg.config} config/configuration.yml

      bundle config build.nokogiri --use-system-libraries --with-iconv-dir=${libiconv} --with-xslt-dir=${libxslt} --with-xml2-dir=${libxml2} --with-pkg-config --with-pg-config=${postgresql}/bin/pg_config

      bundle install --verbose --local --deployment

      # TODO: remove
      GEM_HOME=./vendor/bundle/ruby/1.9.1 ${ruby}/bin/rake generate_secret_token
    '';

    meta = with stdenv.lib; {
      homepage = http://www.redmine.org/;
      platforms = platforms.linux;
      maintainers = [ maintainers.garbas ];
      license = licenses.gpl2;
    };
  };

in {

  options = {
    services.redmine = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the redmine service.
        '';
      };

      stateDir = mkOption {
        type = types.str;
        default = "/var/redmine";
        description = "The state directory, logs and plugins are stored here";
      };

      config = mkOption {
        type = types.str;
        default = ''
          default:
            # Absolute path to the directory where attachments are stored.
            # The default is the 'files' directory in your Redmine instance.
            # Your Redmine instance needs to have write permission on this
            # directory.
            # Examples:
            # attachments_storage_path: /var/redmine/files
            # attachments_storage_path: D:/redmine/files
            attachments_storage_path: ${cfg.stateDir}/files

            # Configuration of the autologin cookie.
            # autologin_cookie_name: the name of the cookie (default: autologin)
            # autologin_cookie_path: the cookie path (default: /)
            # autologin_cookie_secure: true sets the cookie secure flag (default: false)
            autologin_cookie_name:
            autologin_cookie_path:
            autologin_cookie_secure:

            # Absolute path to the SCM commands errors (stderr) log file.
            # The default is to log in the 'log' directory of your Redmine instance.
            # Example:
            # scm_stderr_log_file: /var/log/redmine_scm_stderr.log
            scm_stderr_log_file: ${cfg.stateDir}/redmine_scm_stderr.log
        '';
        description = "Configuration for redmine";
      };

      themes = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = "Set of themes";
      };

      plugins = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = "Set of plugins";
      };

      databaseType = mkOption {
        type = types.str;
        default = "postgresql";
        description = "Type of database";
      };

      databaseName = mkOption {
        type = types.str;
        default = "redmine";
        description = "Database name";
      };

      databaseUsername = mkOption {
        type = types.str;
        default = "redmine";
        description = "Database user";
      };
    };
  };

  config = mkIf cfg.enable {

    users.extraUsers = [
      { name = "redmine";
        group = "redmine";
        uid = config.ids.uids.redmine;
      } ];

    users.extraGroups = [
      { name = "redmine";
        gid = config.ids.gids.redmine;
      } ];

    systemd.services.redmine = {
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      environment.RAILS_ENV = "production";
      environment.GEM_HOME = "${redmine}/vendor/bundle/ruby/1.9.1";
      environment.HOME = "${redmine}";
      environment.REDMINE_LANG = "en";
      environment.GEM_PATH = "${rubyLibs.bundler}/lib/ruby/gems/1.9";
      path = with pkgs; [
        imagemagickBig
        subversion
        mercurial
        cvs
        bazaar
        gitAndTools.git
        # once we build binaries for darc enable it
        #darcs
      ];
      preStart = ''
        for i in db files log tmp public/plugin_assets; do
          mkdir -p ${cfg.stateDir}/$i
        done
        touch ${cfg.stateDir}/db/schema.rb

        chown -R redmine:redmine ${cfg.stateDir}
        chmod -R 755 ${cfg.stateDir}

        if ! test -e "${cfg.stateDir}/db-created"; then
          # TODO: support other dbs
          ${config.services.postgresql.package}/bin/createuser --no-superuser --no-createdb --no-createrole redmine || true
          ${config.services.postgresql.package}/bin/createdb --owner redmine redmine || true
          #${ruby}/bin/rake generate_secret_token
          touch "${cfg.stateDir}/db-created"
        fi

        cd ${redmine}
        /var/setuid-wrappers/sudo -u redmine -E -- ${ruby}/bin/rake db:migrate
        /var/setuid-wrappers/sudo -u redmine -E -- ${ruby}/bin/rake redmine:plugins:migrate
        /var/setuid-wrappers/sudo -u redmine -E -- ${ruby}/bin/rake redmine:load_default_data
      '';

      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        Type = "simple";
        User = "redmine";
        Group = "redmine";
        TimeoutSec = "300";
        WorkingDirectory = "${redmine}";
        ExecStart="${ruby}/bin/ruby ${redmine}/script/rails server webrick -e production";
      };

    };

  };

}
