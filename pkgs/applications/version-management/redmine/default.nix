{ stdenv, fetchurl, bundlerEnv, ruby }:

let
  version = "3.4.6";
  rubyEnv = bundlerEnv {
    name = "redmine-env-${version}";

    inherit ruby;
    gemdir = ./.;
  };
in
  stdenv.mkDerivation rec {
    name = "redmine-${version}";

    src = fetchurl {
      url = "https://www.redmine.org/releases/${name}.tar.gz";
      sha256 = "15akq6pn42w7cf7dg45xmvw06fixck1qznp7s8ix7nyxlmcyvcg3";
    };

    buildInputs = [ rubyEnv rubyEnv.wrappedRuby rubyEnv.bundler ];

    buildPhase = ''
      mv config config.dist
    '';

    installPhase = ''
      mkdir -p $out/share
      cp -r . $out/share/redmine

      for i in config files log plugins tmp; do
        rm -rf $out/share/redmine/$i
        ln -fs /run/redmine/$i $out/share/redmine/
      done
    '';

    meta = with stdenv.lib; {
      homepage = http://www.redmine.org/;
      platforms = platforms.linux;
      maintainers = [ maintainers.garbas ];
      license = licenses.gpl2;
    };
  }
