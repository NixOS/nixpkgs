{ stdenv, fetchurl, libX11, libXinerama, libXft, zlib, patches ? null }:

stdenv.mkDerivation rec {
  name = "dmenu-4.7";

  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "1fgph549i0yw62x02jhfc8qmqk2rnzcnm46bxq6jig1cvkw3amm7";
  };

  buildInputs = [ libX11 libXinerama zlib libXft ];

  inherit patches;

  postPatch = ''
    sed -ri -e 's!\<(dmenu|dmenu_path|stest)\>!'"$out/bin"'/&!g' dmenu_run
    sed -ri -e 's!\<stest\>!'"$out/bin"'/&!g' dmenu_path
  '';

  preConfigure = ''
    sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk
  '';

  meta = with stdenv.lib; {
      description = "A generic, highly customizable, and efficient menu for the X Window System";
      homepage = http://tools.suckless.org/dmenu;
      license = licenses.mit;
      maintainers = with maintainers; [ viric pSub ];
      platforms = platforms.all;
  };
}
