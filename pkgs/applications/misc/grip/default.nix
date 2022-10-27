{ lib
, stdenv
, fetchurl
, gtk2
, pkg-config
, curl
, cdparanoia
, libid3tag
, libtool
}:

stdenv.mkDerivation rec {
  pname = "grip";
  version = "4.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/grip/grip-${version}.tar.gz";
    sha256 = "sha256-5Qgsf4+xs0ckhYJk2csKulXC3nWaLRAsQ15qaTkKkjw=";
  };

  nativeBuildInputs = [ pkg-config libtool ];
  buildInputs = [
    gtk2
    curl
    cdparanoia
    libid3tag
  ];
  enableParallelBuilding = true;

  meta = {
    description = "GTK-based audio CD player/ripper";
    homepage = "http://nostatic.org/grip";
    license = lib.licenses.gpl2Plus;

    maintainers = with lib.maintainers; [ marcweber ];
    platforms = lib.platforms.linux;
  };
}
