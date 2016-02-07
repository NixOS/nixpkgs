{ stdenv, fetchurl, libX11, libXinerama, libXft, zlib, patches ? null }:

stdenv.mkDerivation rec {
  name = "dmenu-4.6";

  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "1cwnvamqqlgczvd5dv5rsgqbhv8kp0ddjnhmavb3q732i8028yja";
  };

  buildInputs = [ libX11 libXinerama zlib libXft ];

  inherit patches;

  postPatch = ''
    sed -ri -e 's!\<(dmenu|stest)\>!'"$out/bin"'/&!g' dmenu_run
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
