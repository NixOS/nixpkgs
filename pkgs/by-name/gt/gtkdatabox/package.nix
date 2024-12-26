{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk3,
  pango,
  cairo,
}:

stdenv.mkDerivation rec {
  pname = "gtkdatabox";
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/gtkdatabox/${pname}-${version}.tar.gz";
    sha256 = "1qykm551bx8j8pfgxs60l2vhpi8lv4r8va69zvn2594lchh71vlb";
  };

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [
    gtk3
    pango
    cairo
  ];

  meta = {
    description = "GTK widget for displaying large amounts of numerical data";
    homepage = "https://gtkdatabox.sourceforge.io/";
    license = lib.licenses.lgpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ yl3dy ];
  };
}
