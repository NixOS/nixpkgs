{ stdenv, buildEnv, fetchgit, fetchurl, ruby_2_1, rubygemsFun
, libxml2, libxslt, openssl, writeScriptBin, sqlite
, dataDir ? "/var/lib/panamax-ui" }:
let
  ruby = ruby_2_1;
  rubygems = rubygemsFun ruby_2_1;

  gemspec = map (gem: fetchurl { url=gem.url; sha256=gem.hash; }) (import ./Gemfile-ui.nix);

  srcs = {
    bundler = fetchurl {
      url = "http://rubygems.org/downloads/bundler-1.7.9.gem";
      sha256 = "1gd201rh17xykab9pbqp0dkxfm7b9jri02llyvmrc0c5bz2vhycm";
    };
  };

  panamax_ui = stdenv.mkDerivation rec {
    name = "panamax-ui-${version}";
    version = "0.2.11";

    src = fetchgit {
      rev = "refs/tags/v${version}";
      url = "git://github.com/CenturyLinkLabs/panamax-ui";
      sha256 = "17j5ac8fzp377bzg7f239jdcc9j0c63bkx0ill5nl10i3h05z7jh";
    };

    buildInputs = [ ruby openssl sqlite ];
    installPhase = ''
      mkdir -p $out/share/panamax-ui
      cp -R . $out/share/panamax-ui
      cd $out/share/panamax-ui

      find . -type f -iname "*.haml" -exec sed -e 's|CoreOS Journal|NixOS Journal|g' -i "{}" \;
      find . -type f -iname "*.haml" -exec sed -e 's|CoreOS Local|NixOS Local|g' -i "{}" \;
      find . -type f -iname "*.haml" -exec sed -e 's|CoreOS Host|NixOS Host|g' -i "{}" \;
      sed -e 's|CoreOS Local|NixOS Local|g' -i "spec/features/manage_application_spec.rb"

      export HOME=$PWD
      export GEM_HOME=$PWD
      export PATH="${rubygems}/bin:$PATH"

      mkdir -p vendor/cache
      ${stdenv.lib.concatStrings (map (gem: "ln -s ${gem} vendor/cache/${gem.name};") gemspec)}

      ${"ln -s ${srcs.bundler} vendor/cache/${srcs.bundler.name};"}
      gem install --local vendor/cache/${srcs.bundler.name}

      bin/bundle install --verbose --local --without development test

      rm -f ./bin/*

      ./gems/bundler-*/bin/bundle exec rake rails:update:bin

      rm -rf log
      ln -sf ${dataDir}/state/log .
      rm -rf tmp
      ln -sf ${dataDir}/state/tmp .
      rm -rf db
      ln -sf ${dataDir}/db .
    '';
  };

  panamax_ui_run = writeScriptBin "panamax-ui-run" ''
    #!${stdenv.shell}

    cd ${panamax_ui}/share/panamax-ui
    export PATH="${panamax_ui}/share/panamax-ui/bin:${ruby}/bin:$PATH"
    export RAILS_ENV="production"
    export HOME="${panamax_ui}/share/panamax-ui"
    export GEM_HOME="${panamax_ui}/share/panamax-ui"
    export GEM_PATH="${panamax_ui}/share/panamax-ui"

    echo ${panamax_ui}/share/panamax-ui

    mkdir -p ${dataDir}/state/log
    mkdir -p ${dataDir}/state/tmp
    mkdir -p ${dataDir}/db

    export PMX_API_PORT_3000_TCP_ADDR=localhost
    bin/rails server $@
  '';

in
  stdenv.mkDerivation rec {
    name = panamax_ui.name;

    unpackPhase = "true";

    installPhase = ''
      mkdir -p $out/bin
      ln -s ${panamax_ui_run}/bin/* $out/bin
    '';

    meta = with stdenv.lib; {
      homepage = https://github.com/CenturyLinkLabs/panamax-ui;
      description = "The Web GUI for Panamax";
      license = licenses.asl20;
      maintainers = with maintainers; [ matejc ];
      platforms = platforms.linux;
    };
  }
