{ lib, stdenv, fetchurl, bundlerEnv, ruby, makeWrapper, nixosTests }:

let
  version = "5.1.3";
  rubyEnv = bundlerEnv {
    name = "redmine-env-${version}";

    inherit ruby;
    gemdir = ./.;
    groups = [ "development" "ldap" "markdown" "common_mark" "minimagick" "test" ];
  };
in
  stdenv.mkDerivation rec {
    pname = "redmine";
    inherit version;

    src = fetchurl {
      url = "https://www.redmine.org/releases/redmine-${version}.tar.gz";
      hash = "sha256-iiIyD9nJQOZZjzrV+3o5MxlchgaO7plLpvzcIsXOy1k=";
    };

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ rubyEnv rubyEnv.wrappedRuby rubyEnv.bundler ];

    # taken from https://www.redmine.org/issues/33784
    # can be dropped when the upstream bug is closed and the fix is present in the upstream release
    patches = [ ./0001-python3.patch ];

    buildPhase = ''
      mv config config.dist
      mv public/themes public/themes.dist
    '';

    installPhase = ''
      mkdir -p $out/bin $out/share
      cp -r . $out/share/redmine
      for i in config files log plugins public/plugin_assets public/themes tmp; do
        rm -rf $out/share/redmine/$i
        ln -fs /run/redmine/$i $out/share/redmine/$i
      done

      makeWrapper ${rubyEnv.wrappedRuby}/bin/ruby $out/bin/rdm-mailhandler.rb --add-flags $out/share/redmine/extra/mail_handler/rdm-mailhandler.rb
    '';

    passthru.tests.redmine = nixosTests.redmine;

    meta = with lib; {
      homepage = "https://www.redmine.org/";
      changelog = "https://www.redmine.org/projects/redmine/wiki/changelog";
      platforms = platforms.linux;
      maintainers = with maintainers; [ aanderse felixsinger megheaiulian ];
      license = licenses.gpl2;
    };
  }
