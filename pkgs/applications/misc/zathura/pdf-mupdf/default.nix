{ stdenv, lib, fetchurl, pkgconfig, zathura_core, gtk, girara, mupdf, openssl }:

stdenv.mkDerivation rec {
  version = "0.3.0";
  name = "zathura-pdf-mupdf-${version}";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-pdf-mupdf/download/${name}.tar.gz";
    sha256 = "1j3j3wbp49walb19f0966qsnlqbd26wnsjpcxfbf021dav8vk327";
  };

  buildInputs = [ pkgconfig zathura_core gtk girara openssl mupdf ];

  makeFlags = [ "PREFIX=$(out)" "PLUGINDIR=$(out)/lib" ];

  patches = [
    ./config.patch
  ];

  meta = with lib; {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A zathura PDF plugin (mupdf)";
    longDescription = ''
      The zathura-pdf-mupdf plugin adds PDF support to zathura by
      using the mupdf rendering library.
    '';
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
