{ stdenv, fetchurl, pkgconfig, zathura_core, girara, poppler, gettext }:

stdenv.mkDerivation rec {
  name = "zathura-pdf-poppler-0.1.1";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "bec5fee721fcaee9f4b53d3882908b19efa82815393aa8c3619ff948b909d4a7";
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
    license = "free";
    platforms = stdenv.lib.platforms.linux;
  };
}
