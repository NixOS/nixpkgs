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
  version = "0.22.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-Ui7XoLSzTMPIFW/3nARCmvlGF+1l7pmcnKsnvn3NFJE=";
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
    platforms = platforms.darwin ++ platforms.linux;
  };
}
