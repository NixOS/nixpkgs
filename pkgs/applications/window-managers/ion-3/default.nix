{ stdenv, fetchurl, x11, lua, gettext, groff }:

stdenv.mkDerivation {
  name = "ion-3rc-20070902";
  meta = {
    description = "Ion is a tiling tabbed window manager designed with keyboard users in mind.";
    homepage = http://modeemi.fi/~tuomov/ion;
  };
  src = fetchurl {
    url = http://iki.fi/tuomov/dl/ion-3rc-20070902.tar.gz;
    sha256 = "062a0rgxzz4h1hih5lp7l2nfvhz095brag9fmnanzqc4dac228xl";
  };
  buildInputs = [ x11 lua gettext groff ];
  buildFlags = "LUA_DIR=${lua} X11_PREFIX=/no-such-path PREFIX=\${out}";
  installFlags = "PREFIX=\${out}";
}
