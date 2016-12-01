{ stdenv, fetchurl, xlibsWrapper, lua, gettext, mandoc }:

stdenv.mkDerivation {
  name = "ion-3-2009-01-10";
  meta = with stdenv.lib; {
    description = "Tiling tabbed window manager designed with keyboard users in mind";
    homepage = http://modeemi.fi/~tuomov/ion;
    platforms = platforms.linux;
  };
  src = fetchurl {
    url = http://tuomov.iki.fi/software/dl/ion-3-20090110.tar.gz;
    sha256 = "1nkks5a95986nyfkxvg2rik6zmwx0lh7szd5fji7yizccwzc9xns";
  };
  postPatch = ''
    substituteInPlace man/Makefile \
      --replace "nroff -man -Tlatin1"  "${mandoc}/bin/mandoc -T man"
  '';
  buildInputs = [ xlibsWrapper lua gettext mandoc ];
  buildFlags = "LUA_DIR=${lua} X11_PREFIX=/no-such-path PREFIX=\${out}";
  installFlags = "PREFIX=\${out}";
}
