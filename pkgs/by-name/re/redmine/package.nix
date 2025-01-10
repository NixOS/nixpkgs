{ lib, stdenv, fetchurl, bundlerEnv, ruby_3_2, makeWrapper, nixosTests }:

let
  version = "5.1.5";
  rubyEnv = bundlerEnv {
    name = "redmine-env-${version}";

    ruby = ruby_3_2;
    gemdir = ./.;
    groups = [ "development" "ldap" "markdown" "common_mark" "minimagick" "test" ];
  };
in
  stdenv.mkDerivation rec {
    pname = "redmine";
    inherit version;

    src = fetchurl {
      url = "https://www.redmine.org/releases/redmine-${version}.tar.gz";
      hash = "sha256-LJc5URcS/BOB2VhPoAX5EaMCLoNm0dalP+wPAU2sAWg=";
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
      knownVulnerabilities = [ "CVE-2024-54133" "GHSA-r95h-9x8f-r3f7" ];
    };
  }
