{ stdenv
, lib
, fetchurl
, gtk3
, glib
, pkg-config
, libpng
, zlib
}:

stdenv.mkDerivation rec {
  pname = "xmedcon";
  version = "0.21.0";

  src = fetchurl {
    url = "https://prdownloads.sourceforge.net/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0yfnbrcil5i76z1wbg308pb1mnjbcxy6nih46qpqs038v1lhh4q8";
  };

  buildInputs = [
    gtk3
    glib
    libpng
    zlib
  ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "An open source toolkit for medical image conversion ";
    homepage = "https://xmedcon.sourceforge.io/Main/HomePage";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ arianvp flokli ];
    platforms = with platforms; [ darwin linux ];
  };
}
