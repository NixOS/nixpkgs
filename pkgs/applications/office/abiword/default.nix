{ stdenv, fetchurl, pkgconfig, gtk3, libglade, libgnomecanvas, fribidi
, libpng, popt, libgsf, enchant, wv, librsvg, bzip2, libjpeg, perl
, boost, libxslt, goffice, makeWrapper, iconTheme
}:

stdenv.mkDerivation rec {
  name = "abiword-${version}";
  version = "3.0.2";

  src = fetchurl {
    url = "http://www.abisource.com/downloads/abiword/${version}/source/${name}.tar.gz";
    sha256 = "08imry821g81apdwym3gcs4nss0l9j5blqk31j5rv602zmcd9gxg";
  };

  enableParallelBuilding = true;

  patches = [
    ./patches/fix-13791.patch
  ];

  buildInputs =
    [ pkgconfig gtk3 libglade librsvg bzip2 libgnomecanvas fribidi libpng popt
      libgsf enchant wv libjpeg perl boost libxslt goffice makeWrapper iconTheme
    ];

  postFixup = ''
    wrapProgram "$out/bin/abiword" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Word processing program, similar to Microsoft Word";
    homepage = http://www.abisource.com/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ylwghst ];
  };
}
