{ stdenv, lib, fetchurl, pkgconfig, zathura_core, gtk, girara, mupdf, openssl }:

stdenv.mkDerivation rec {
  version = "0.2.8";
  name = "zathura-pdf-mupdf-${version}";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-pdf-mupdf/download/${name}.tar.gz";
    sha256 = "0439ls8xqnq6hqa53hd0wqxh1qf0xmccfi3pb0m4mlfs5iv952wz";
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
