{ stdenv, lib, meson, ninja, fetchurl, fetchpatch
, cairo
, girara
, gtk-mac-integration
, gumbo
, jbig2dec
, libjpeg
, mupdf
, openjpeg
, pkg-config
, zathura_core
}:

stdenv.mkDerivation rec {
  version = "0.3.7";
  pname = "zathura-pdf-mupdf";

  src = fetchurl {
    url = "https://pwmt.org/projects/${pname}/download/${pname}-${version}.tar.xz";
    sha256 = "07d2ds9yqfrl20z3yfgc55vwg10mwmcg2yvpr4j66jjd5mlal01g";
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
  ] ++ lib.optional stdenv.isDarwin gtk-mac-integration;

  mesonFlags = [
    "-Dlink-external=true"
  ];

  # avoid: undefined symbol: gumbo_destroy_output
  NIX_LDFLAGS = [ "-lgumbo" ];

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
