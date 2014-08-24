{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.redmine;

  ruby = pkgs.ruby2;
  rubyLibs = pkgs.ruby2Libs;

  gemspec = map (gem: pkgs.fetchurl { url=gem.url; sha256=gem.hash; })
    (import <nixpkgs/pkgs/applications/version-management/redmine/Gemfile.nix>);

  redmine = with pkgs; stdenv.mkDerivation rec {
    version = "2.5.2";
    name = "redmine-${version}";
    src = fetchurl {
      url = "http://www.redmine.org/releases/${name}.tar.gz";
      sha256 = "0x0zwxyj4dwbk7l64s3lgny10mjf0ba8jwrbafsm4d72sncmacv0";
    };
    buildInputs = [
      ruby rubyLibs.bundler libiconv libxslt libxml2 pkgconfig libffi
      imagemagick postgresql
    ];
    installPhase = ''
      cp -R . $out
      cd $out
      ln -s ${<nixpkgs/pkgs/applications/version-management/redmine/Gemfile.lock>} Gemfile.lock
      export HOME=$(pwd)

      mkdir -p vendor/cache

      ${concatStrings (map (gem: "ln -s ${gem} vendor/cache/${gem.name};") gemspec)}

      rm -R files log tmp
      for i in files log tmp; do
        ln -s ${cfg.stateDir}/$i $i
      done

      ln -s ${cfg.stateDir}/db/schema.rb db/schema.rb

      cat > config/database.yml <<EOF
      production:
        adapter: postgresql
        database: redmine
        host: 127.0.0.1
        username: redmine
        password: 12345
        encoding: utf8
      EOF

      bundle config build.nokogiri --use-system-libraries --with-iconv-dir=${libiconv} --with-xslt-dir=${libxslt} --with-xml2-dir=${libxml2} --with-pkg-config --with-pg-config=${postgresql}/bin/pg_config
      bundle install --verbose --local --deployment
      rake generate_secret_token
    '';
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

    };
  };

  config = mkIf cfg.enable {

    users.extraUsers = [
      { name = "redmine";
        description = "Redmine daemon";
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
      environment.GEM_HOME = "${redmine}/vendor/bundle/ruby/${ruby.majorVersion}.${ruby.minorVersion}";
      environment.HOME = "${redmine}";
      environment.REDMINE_LANG = "en";
      environment.GEM_PATH = "${rubyLibs.bundler}/lib/ruby/gems/2.0";
      path = [ redmine ];
      preStart = ''

        for i in db files log tmp public/plugin_assets; do
          mkdir -p ${cfg.stateDir}/$i
        done
        touch ${cfg.stateDir}/db/schema.rb

        chown -R redmine:redmine ${cfg.stateDir}
        chmod -R 755 ${cfg.stateDir}

        cd ${redmine}
        ${ruby}/bin/rake db:migrate
        ${ruby}/bin/rake redmine:load_default_data
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
