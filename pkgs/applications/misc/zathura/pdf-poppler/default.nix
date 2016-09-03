{ stdenv, lib, fetchurl, pkgconfig, zathura_core, girara, poppler }:

stdenv.mkDerivation rec {
  version = "0.2.6";
  name = "zathura-pdf-poppler-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "1maqiv7yv8d8hymlffa688c5z71v85kbzmx2j88i8z349xx0rsyi";
  };

  buildInputs = [ pkgconfig poppler zathura_core girara ];

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
