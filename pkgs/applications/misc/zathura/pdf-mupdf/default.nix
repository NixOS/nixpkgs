{ stdenv, lib, fetchurl, pkgconfig, zathura_core, gtk, girara, mupdf, openssl
, libjpeg, jbig2dec, openjpeg, fetchpatch }:

stdenv.mkDerivation rec {
  version = "0.3.1";
  name = "zathura-pdf-mupdf-${version}";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-pdf-mupdf/download/${name}.tar.gz";
    sha256 = "06zqn8z6a0hfsx3s1kzqvqzb73afgcl6z5r062sxv7kv570fvffr";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zathura_core gtk girara openssl mupdf libjpeg jbig2dec openjpeg ];

  makeFlags = [ "PREFIX=$(out)" "PLUGINDIR=$(out)/lib" ];

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
