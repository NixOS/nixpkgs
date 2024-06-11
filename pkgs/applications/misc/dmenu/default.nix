{ lib, stdenv, fetchurl, libX11, libXinerama, libXft, zlib, patches ? null
# update script dependencies
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "dmenu";
  version = "5.3";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/dmenu-${version}.tar.gz";
    sha256 = "sha256-Go9T5v0tdJg57IcMXiez4U2lw+6sv8uUXRWeHVQzeV8=";
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

  passthru.updateScript = gitUpdater {
    url = "git://git.suckless.org/dmenu";
  };

  meta = with lib; {
    description = "Generic, highly customizable, and efficient menu for the X Window System";
    homepage = "https://tools.suckless.org/dmenu";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub globin qusic ];
    platforms = platforms.all;
    mainProgram = "dmenu";
  };
}
