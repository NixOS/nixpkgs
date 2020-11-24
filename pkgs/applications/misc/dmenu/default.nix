{ stdenv, fetchurl, libX11, libXinerama, libXft, zlib, patches ? null }:

stdenv.mkDerivation rec {
  name = "dmenu-5.0";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "1lvfxzg3chsgcqbc2vr0zic7vimijgmbvnspayx73kyvqi1f267y";
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

  makeFlags = [ "CC:=$(CC)" ];

  meta = with stdenv.lib; {
      description = "A generic, highly customizable, and efficient menu for the X Window System";
      homepage = "https://tools.suckless.org/dmenu";
      license = licenses.mit;
      maintainers = with maintainers; [ pSub globin ];
      platforms = platforms.all;
  };
}
