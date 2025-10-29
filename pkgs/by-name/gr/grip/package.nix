{
  lib,
  stdenv,
  fetchurl,
  gtk2,
  pkg-config,
  curl,
  cdparanoia,
  libid3tag,
  libtool,
}:

stdenv.mkDerivation rec {
  pname = "grip";
  version = "4.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/grip/grip-${version}.tar.gz";
    sha256 = "sha256-lXu0mLLfcX8K1EmoFH0vp2cHluyRwhTL0/bW5Ax36mI=";
  };

  nativeBuildInputs = [
    pkg-config
    libtool
  ];
  buildInputs = [
    gtk2
    curl
    cdparanoia
    libid3tag
  ];
  enableParallelBuilding = true;

  meta = {
    description = "GTK-based audio CD player/ripper";
    homepage = "https://sourceforge.net/projects/grip/";
    license = lib.licenses.gpl2Plus;

    maintainers = with lib.maintainers; [ marcweber ];
    platforms = lib.platforms.linux;
    mainProgram = "grip";
  };
}
