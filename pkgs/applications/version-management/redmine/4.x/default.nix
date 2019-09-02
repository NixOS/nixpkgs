{ stdenv, fetchurl, bundlerEnv, ruby }:

let
  version = "4.0.4";
  rubyEnv = bundlerEnv {
    name = "redmine-env-${version}";

    inherit ruby;
    gemdir = ./.;
    groups = [ "ldap" "openid" ];
  };
in
  stdenv.mkDerivation rec {
    pname = "redmine";
    inherit version;

    src = fetchurl {
      url = "https://www.redmine.org/releases/${pname}-${version}.tar.gz";
      sha256 = "0i5bmgdi3mahbis9hn0hk53rnz4ihp9yij4b4i07ny9vf3n4kp1a";
    };

    buildInputs = [ rubyEnv rubyEnv.wrappedRuby rubyEnv.bundler ];

    buildPhase = ''
      mv config config.dist
      mv public/themes public/themes.dist
    '';

    installPhase = ''
      mkdir -p $out/share
      cp -r . $out/share/redmine
      for i in config files log plugins public/plugin_assets public/themes tmp; do
        rm -rf $out/share/redmine/$i
        ln -fs /run/redmine/$i $out/share/redmine/$i
      done
    '';

    meta = with stdenv.lib; {
      homepage = http://www.redmine.org/;
      platforms = platforms.linux;
      maintainers = [ maintainers.aanderse ];
      license = licenses.gpl2;
    };
  }
