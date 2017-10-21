{stdenv, fetchhg, libX11, libXinerama, libXft, zlib}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "dmenu2-0.3pre-2014-07-08";

  src = fetchhg {
    url = "https://bitbucket.org/melek/dmenu2";
    rev = "36cb94a16edf928bdaaa636123392517ed469be0";
    sha256 = "1b17z5ypg6ij7zz3ncp3irc87raccna10y4w490c872a99lp23lv";
  };

  buildInputs = [ libX11 libXinerama zlib libXft ];

  postPatch = ''
    sed -ri -e 's!\<(dmenu|stest)\>!'"$out/bin"'/&!g' dmenu_run
  '';

  preConfigure = [ ''sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk'' ];

  meta = {
      description = "A patched fork of the original dmenu - an efficient dynamic menu for X";
      homepage = https://bitbucket.org/melek/dmenu2;
      license = licenses.mit;
      maintainers = [ maintainers.cstrahan ];
      platforms = platforms.all;
  };
}
