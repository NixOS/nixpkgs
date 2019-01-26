{ stdenv, fetchurl, libX11, libXinerama, libXft, zlib, patches ? null }:

stdenv.mkDerivation rec {
  name = "dmenu-4.8";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "0qfvfrj10xlwd9hkvb57wshryan65bl6423h0qhiw1h76rf5lqgy";
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
      homepage = https://tools.suckless.org/dmenu;
      license = licenses.mit;
      maintainers = with maintainers; [ pSub ];
      platforms = platforms.all;
  };
}
