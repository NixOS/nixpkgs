{ stdenv
, fetchurl
, pkgconfig
, gtk2
, bison
, intltool
, flex
, netpbm
, imagemagick
, dbus
, xlibsWrapper
, libGLU
, libGL
, shared-mime-info
, tcl
, tk
, gnome2
, gd
, xorg
}:

stdenv.mkDerivation rec {
  pname = "pcb";
  version = "4.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/pcb/${pname}-${version}.tar.gz";
    sha256 = "1i9zvcj0vgwp2g2hkmvafdq0k39klj90jsdanqx9xl7gl70345cq";
  };

  nativeBuildInputs = [
    pkgconfig
    bison
    intltool
    flex
    netpbm
    imagemagick
  ];

  buildInputs = [
    gtk2
    dbus
    xlibsWrapper
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

  meta = with stdenv.lib; {
    description = "Printed Circuit Board editor";
    homepage = http://pcb.geda-project.org/;
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
