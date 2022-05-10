{ stdenv, gnulib, gettext, autoconf, automake, makeSetupHook }:
let
  cache = stdenv.mkDerivation {
    name = "config.cache";
    src = ./src;

    nativeBuildInputs = [ gnulib gettext autoconf automake ];
    buildPhase = ''
      gnulib-tool --list | xargs gnulib-tool --import
      autoreconf --install --force
      ./configure --config-cache
    '';
    installPhase = ''
      cp config.cache $out
    '';
  };
in makeSetupHook {
  name = "autoconf-cache";
  substitutions = { inherit cache; };
} ./setup-hook.in
