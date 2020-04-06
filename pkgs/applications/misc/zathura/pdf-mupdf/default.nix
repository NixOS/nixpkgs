{ stdenv, lib, meson, ninja, fetchurl
, pkgconfig, zathura_core, cairo , gtk-mac-integration, girara, mupdf }:

stdenv.mkDerivation rec {
  version = "0.3.5";
  pname = "zathura-pdf-mupdf";

  src = fetchurl {
    url = "https://pwmt.org/projects/${pname}/download/${pname}-${version}.tar.xz";
    sha256 = "1pjwsb7zwclxsvz229fl7y2saf1pv3ifwv3ay8viqxgrp9x3z9hq";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [
    zathura_core girara mupdf cairo
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
