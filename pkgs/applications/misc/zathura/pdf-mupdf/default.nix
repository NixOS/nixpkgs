{ stdenv, lib, meson, ninja, fetchurl, cairo
, girara
, gtk-mac-integration
, gumbo
, jbig2dec
, libjpeg
, mupdf
, openjpeg
, pkg-config
, zathura_core
, tesseract
, leptonica
, mujs
}:

stdenv.mkDerivation rec {
  version = "0.4.0";
  pname = "zathura-pdf-mupdf";

  src = fetchurl {
    url = "https://pwmt.org/projects/${pname}/download/${pname}-${version}.tar.xz";
    sha256 = "0pcjxvlh4hls8mjhjghhhihyy2kza8l27wdx0yq4bkd1g1b5f74c";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [
    cairo
    girara
    gumbo
    jbig2dec
    libjpeg
    mupdf
    openjpeg
    zathura_core
    tesseract
    leptonica
    mujs
  ] ++ lib.optional stdenv.isDarwin gtk-mac-integration;

  PKG_CONFIG_ZATHURA_PLUGINDIR= "lib/zathura";

  meta = with lib; {
    homepage = "https://pwmt.org/projects/zathura-pdf-mupdf/";
    description = "A zathura PDF plugin (mupdf)";
    longDescription = ''
      The zathura-pdf-mupdf plugin adds PDF support to zathura by
      using the mupdf rendering library.
    '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cstrahan ];
  };
}
