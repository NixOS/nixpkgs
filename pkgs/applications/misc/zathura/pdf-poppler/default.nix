{ stdenv, lib, fetchurl, pkgconfig, zathura_core, girara, poppler }:

stdenv.mkDerivation rec {
  version = "0.2.8";
  name = "zathura-pdf-poppler-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "1m55m7s7f8ng8a7lmcw9z4n5zv7xk4vp9n6fp9j84z6rk2imf7a2";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ poppler zathura_core girara ];

  makeFlags = [ "PREFIX=$(out)" "PLUGINDIR=$(out)/lib" ];

  meta = with lib; {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A zathura PDF plugin (poppler)";
    longDescription = ''
      The zathura-pdf-poppler plugin adds PDF support to zathura by
      using the poppler rendering library.
    '';
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan garbas ];
  };
}
