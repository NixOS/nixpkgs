{ stdenv, fetchurl, xlibsWrapper, lua, gettext, groff }:

stdenv.mkDerivation {
  name = "ion-3-20090110";
  meta = {
    description = "Tiling tabbed window manager designed with keyboard users in mind";
    homepage = http://modeemi.fi/~tuomov/ion;
    platforms = with stdenv.lib.platforms; linux;
    license = stdenv.lib.licenses.lgpl21;
  };
  src = fetchurl {
    url = http://tuomov.iki.fi/software/dl/ion-3-20090110.tar.gz;
    sha256 = "1nkks5a95986nyfkxvg2rik6zmwx0lh7szd5fji7yizccwzc9xns";
  };
  buildInputs = [ xlibsWrapper lua gettext groff ];
  buildFlags = [ "LUA_DIR=${lua}" "X11_PREFIX=/no-such-path" "PREFIX=\${out}" ];
  installFlags = [ "PREFIX=\${out}" ];
}
