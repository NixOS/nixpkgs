{ stdenv, fetchurl, x11, lua, gettext, groff }:

stdenv.mkDerivation {
  name = "ion-3rc-20070608";
  meta = {
	  description = "Ion is a tiling tabbed window manager designed with keyboard users in mind.";
	  homepage = http://modeemi.fi/~tuomov/ion;
  };
  src = fetchurl {
    url =  ftp://ftp.chg.ru/pub/Linux/gentoo/distfiles/ion-3rc-20070608.tar.gz;
    sha256 = "1s46vbm74vjdjmnz8dczk9km8lhwnw63mziwb2ymib63c6gxifhy";
  };
  buildInputs = [ x11 lua gettext groff ];
  buildFlags = "LUA_DIR=${lua} X11_PREFIX=/no-such-path PREFIX=\${out}";
  installFlags = "PREFIX=\${out}";
}
