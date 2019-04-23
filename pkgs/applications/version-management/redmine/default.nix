{ stdenv, fetchurl, bundlerEnv, ruby }:

let
  version = "3.4.10";
  rubyEnv = bundlerEnv {
    name = "redmine-env-${version}";

    inherit ruby;
    gemdir = ./.;
    groups = [ "ldap" "openid" ];
  };
in
  stdenv.mkDerivation rec {
    name = "redmine-${version}";

    src = fetchurl {
      url = "https://www.redmine.org/releases/${name}.tar.gz";
      sha256 = "08clfg7wgp4wnajawdn7qgrv7r8lk8d8haqkl7iz77ygdi3mpyrh";
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
      maintainers = [ maintainers.garbas maintainers.aanderse ];
      license = licenses.gpl2;
    };
  }
