{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk2,
  bison,
  intltool,
  flex,
  netpbm,
  imagemagick,
  dbus,
  freetype,
  fontconfig,
  libGLU,
  libGL,
  shared-mime-info,
  tcl,
  tk,
  gnome2,
  gd,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "pcb";
  version = "4.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/pcb/${pname}-${version}.tar.gz";
    sha256 = "sha256-roUvRq+Eq6f1HYE/uRb8f82+6kP3E08VBQcCThdD+14=";
  };

  nativeBuildInputs = [
    pkg-config
    bison
    intltool
    flex
    netpbm
    imagemagick
  ];

  buildInputs = [
    gtk2
    dbus
    xorg.libXrender
    freetype
    fontconfig
    libGLU
    libGL
    tcl
    shared-mime-info
    tk
    gnome2.gtkglext
    gd
    xorg.libXmu
  ];

  configureFlags = [
    "--disable-update-desktop-database"
  ];

  meta = with lib; {
    description = "Printed Circuit Board editor";
    homepage = "https://sourceforge.net/projects/pcb/";
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
