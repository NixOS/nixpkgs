{ stdenv, fetchurl, pkgconfig, gtk3, fribidi
, libpng, popt, libgsf, enchant, wv, librsvg, bzip2, libjpeg, perl
, boost, libxslt, goffice, wrapGAppsHook, iconTheme
}:

stdenv.mkDerivation rec {
  name = "abiword-${version}";
  version = "3.0.2";

  src = fetchurl {
    url = "https://www.abisource.com/downloads/abiword/${version}/source/${name}.tar.gz";
    sha256 = "08imry821g81apdwym3gcs4nss0l9j5blqk31j5rv602zmcd9gxg";
  };

  enableParallelBuilding = true;

  patches = [
    # https://bugzilla.abisource.com/show_bug.cgi?id=13791
    (fetchurl {
      url = https://bugzilla.abisource.com/attachment.cgi?id=5860;
      sha256 = "02p8kz02xm1197zcpzjs010mna9hxsbq5lwgxr8b7qhh9yxja7al";
    })
  ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [
    gtk3 librsvg bzip2 fribidi libpng popt
    libgsf enchant wv libjpeg perl boost libxslt goffice iconTheme
  ];

  meta = with stdenv.lib; {
    description = "Word processing program, similar to Microsoft Word";
    homepage = https://www.abisource.com/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ylwghst ];
  };
}
