{ stdenv, fetchurl, pkgconfig, zathura_core, girara, poppler, gettext }:

stdenv.mkDerivation rec {
  version = "0.2.4";
  name = "zathura-pdf-poppler-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "1x1n21naixb87g1knznjfjfibazzwbn1cv7d42kxgwlnf1p1wbzm";
  };

  buildInputs = [ pkgconfig poppler gettext zathura_core girara ];

  makeFlags = "PREFIX=$(out) PLUGINDIR=$(out)/lib";

  meta = {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A zathura PDF plugin";
    longDescription = ''
      The zathura-pdf-poppler plugin adds PDF support to zathura by 
      using the poppler rendering engine.
    '';
    license = stdenv.lib.licenses.zlib;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.garbas ];
  };
}
