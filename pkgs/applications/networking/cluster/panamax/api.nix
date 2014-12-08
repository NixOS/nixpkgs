{ stdenv, buildEnv, fetchgit, fetchurl, ruby_2_1, rubygemsFun, libxslt, libxml2
, sqlite, openssl, cacert, writeScriptBin, docker
, dataDir ? "/var/lib/panamax-api" }:
let
  ruby = ruby_2_1;
  rubygems = rubygemsFun ruby_2_1;

  gemspec = map (gem: fetchurl { url=gem.url; sha256=gem.hash; }) (import ./Gemfile-api.nix);

  srcs = {
    bundler = fetchurl {
      url = "http://rubygems.org/downloads/bundler-1.7.9.gem";
      sha256 = "1gd201rh17xykab9pbqp0dkxfm7b9jri02llyvmrc0c5bz2vhycm";
    };
  };

  panamax_api = stdenv.mkDerivation rec {
    name = "panamax-api-${version}";
    version = "0.2.11";

    src = fetchgit {
      rev = "refs/tags/v${version}";
      url = "git://github.com/CenturyLinkLabs/panamax-api";
      sha256 = "01sz7jibn1rqfga85pr4p8wk6jfldzfaxj1726vs6znmcwhfkcgj";
    };

    buildInputs = [ sqlite openssl ruby ];

    installPhase = ''
      mkdir -p $out/share/panamax-api
      cp -R . $out/share/panamax-api
      cd $out/share/panamax-api

      export HOME=$PWD
      export GEM_HOME=$PWD
      export PATH="${rubygems}/bin:$PATH"
      export RAILS_ENV=production

      find . -type f -exec sed -e 's|/usr/bin/docker|${docker}/bin/docker|g' -i "{}" \;

      mkdir -p vendor/cache
      ${stdenv.lib.concatStrings (map (gem: "ln -s ${gem} vendor/cache/${gem.name};") gemspec)}

      ${"ln -s ${srcs.bundler} vendor/cache/${srcs.bundler.name};"}
      gem install --local vendor/cache/${srcs.bundler.name}

      ln -sf ${database_yml} config/database.yml


      bin/bundle install -j4 --verbose --local --deployment

      rm -f ./bin/*

      ./gems/bundler-*/bin/bundle exec rake rails:update:bin

      rm -rf log
      ln -sf ${dataDir}/state/log .
      ln -sf ${dataDir}/state/tmp .
      mv ./db ./_db
      ln -sf ${dataDir}/db .
    '';
  };

  panamax_api_init = writeScriptBin "panamax-api-init" ''
    #!${stdenv.shell}

    test -d ${dataDir}/db && exit 0

    cd ${panamax_api}/share/panamax-api

    export HOME=$PWD
    export GEM_HOME=$PWD
    export PATH="${panamax_api}/share/panamax-api/bin:${ruby}/bin:$PATH"
    export OPENSSL_X509_CERT_FILE="${cacert}/etc/ca-bundle.crt"
    export RAILS_ENV=production

    mkdir -p ${dataDir}/state/log
    mkdir -p ${dataDir}/db/mnt
    ln -sf ${panamax_api}/share/panamax-api/_db/schema.rb ${dataDir}/db/
    ln -sf ${panamax_api}/share/panamax-api/_db/seeds.rb ${dataDir}/db/
    ln -sf ${panamax_api}/share/panamax-api/_db/migrate ${dataDir}/db/

    bundle exec rake db:setup
    bundle exec rake db:seed
    bundle exec rake panamax:templates:load
  '';

  panamax_api_run = writeScriptBin "panamax-api-run" ''
    #!${stdenv.shell}
    cd ${panamax_api}/share/panamax-api
    mkdir -p ${dataDir}/state/tmp
    export HOME=$PWD
    export GEM_HOME=$PWD
    export PATH="${panamax_api}/share/panamax-api/bin:${ruby}/bin:${docker}/bin:$PATH"
    export RAILS_ENV=production
    export SSL_CERT_FILE="${cacert}/etc/ca-bundle.crt"
    bin/bundle exec rails s $@
  '';

  database_yml = builtins.toFile "database.yml" ''
    development:
      adapter: sqlite3
      database: ${dataDir}/db/mnt/development.sqlite3
      pool: 5
      timeout: 5000

    # See corresponding schema load in spec/support/in_memory_database
    test:
      adapter: sqlite3
      database: ":memory:"
      verbosity: quiet

    production:
      adapter: sqlite3
      database: ${dataDir}/db/mnt/production.sqlite3
      pool: 5
      timeout: 5000
  '';

in
  stdenv.mkDerivation rec {
    name = panamax_api.name;

    unpackPhase = "true";

    installPhase = ''
      mkdir -p $out/bin
      ln -s ${panamax_api_init}/bin/* $out/bin
      ln -s ${panamax_api_run}/bin/* $out/bin
    '';

    meta = with stdenv.lib; {
      homepage = https://github.com/CenturyLinkLabs/panamax-api;
      description = "The API behind The Panamax UI";
      license = licenses.asl20;
      maintainers = with maintainers; [ matejc ];
      platforms = platforms.linux;
    };
  }
