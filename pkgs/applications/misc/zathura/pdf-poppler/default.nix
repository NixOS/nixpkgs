{ stdenv, lib, fetchurl, pkgconfig, zathura_core, girara, poppler }:

stdenv.mkDerivation rec {
  version = "0.2.5";
  name = "zathura-pdf-poppler-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "1b0chsds8iwjm4g629p6a67nb6wgra65pw2vvngd7g35dmcjgcv0";
  };

  buildInputs = [ pkgconfig poppler zathura_core girara ];

  makeFlags = "PREFIX=$(out) PLUGINDIR=$(out)/lib";

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
