{ stdenv, fetchurl, pkgconfig, gtk2, bison, intltool, flex
, netpbm, imagemagick, dbus, xlibsWrapper, libGLU_combined
, shared-mime-info, tcl, tk, gnome2, pangox_compat, gd, xorg
}:

stdenv.mkDerivation rec {
  name = "pcb-${version}";
  version = "20140316";

  src = fetchurl {
    url = "http://ftp.geda-project.org/pcb/pcb-20140316/${name}.tar.gz";
    sha256 = "0l6944hq79qsyp60i5ai02xwyp8l47q7xdm3js0jfkpf72ag7i42";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk2 bison intltool flex netpbm imagemagick dbus xlibsWrapper
    libGLU_combined tcl shared-mime-info tk
    gnome2.gtkglext pangox_compat gd xorg.libXmu
  ];

  configureFlags = ["--disable-update-desktop-database"];

  meta = with stdenv.lib; {
    description = "Printed Circuit Board editor";
    homepage = http://pcb.geda-project.org/;
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
