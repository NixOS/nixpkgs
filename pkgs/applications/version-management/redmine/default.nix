{ lib, stdenv, fetchurl, bundlerEnv, ruby, makeWrapper }:

let
  version = "4.2.4";
  rubyEnv = bundlerEnv {
    name = "redmine-env-${version}";

    inherit ruby;
    gemdir = ./.;
    groups = [ "development" "ldap" "markdown" "minimagick" "openid" "test" ];
  };
in
  stdenv.mkDerivation rec {
    pname = "redmine";
    inherit version;

    src = fetchurl {
      # https://www.redmine.org/news/134
      # > "These releases are not available yet on the releases page from a technical reason, we are sorry for this and we expected to have them uploaded next week. I'll post here an update after we have them uploaded."
      url = "https://www.redmine.org/attachments/download/28862/${pname}-${version}.tar.gz";
      sha256 = "7f50fd4a6cf1c1e48091a87696b813ba264e11f04dec67fb006858a1b49a5c7d";
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

    meta = with lib; {
      homepage = "https://www.redmine.org/";
      platforms = platforms.linux;
      maintainers = [ maintainers.aanderse ];
      license = licenses.gpl2;
    };
  }
