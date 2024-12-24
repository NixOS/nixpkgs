{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk3,
  glib,
  glibmm,
  gtkmm3,
  gtkspell3,
}:

stdenv.mkDerivation rec {
  pname = "gtkspellmm";
  version = "3.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/project/gtkspell/gtkspellmm/" + "${pname}-${version}.tar.xz";
    sha256 = "0i8mxwyfv5mskachafa4qlh315q0cfph7s66s1s34nffadbmm1sv";
  };

  propagatedBuildInputs = [
    gtkspell3
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk3
    glib
    glibmm
    gtkmm3
  ];

  meta = with lib; {
    description = "C++ binding for the gtkspell library";
    homepage = "https://gtkspell.sourceforge.net/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
