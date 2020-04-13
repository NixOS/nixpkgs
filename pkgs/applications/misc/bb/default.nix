{ stdenv, lib, fetchurl, darwin, aalib, ncurses, xorg, libmikmod }:

stdenv.mkDerivation rec {
  pname = "bb";
  version = "1.3rc1";

  src = fetchurl {
    url    = "mirror://sourceforge/aa-project/bb/${version}/${pname}-${version}.tar.gz";
    sha256 = "1i411glxh7g4pfg4gw826lpwngi89yrbmxac8jmnsfvrfb48hgbr";
  };

  buildInputs = [
    aalib ncurses libmikmod
    xorg.libXau xorg.libXdmcp xorg.libX11
  ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.CoreAudio;

  postPatch = lib.optionalString stdenv.isDarwin ''
    sed -i -e '/^#include <malloc.h>$/d' *.c
  '';

  meta = with lib; {
    homepage    = "http://aa-project.sourceforge.net/bb";
    description = "AA-lib demo";
    license     = licenses.gpl2;
    maintainers = [ maintainers.rnhmjoj ];
    platforms   = platforms.unix;
  };
}
