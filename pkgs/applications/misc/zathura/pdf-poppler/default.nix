{ stdenv, fetchurl, pkgconfig, zathura_core, girara, poppler, gettext }:

stdenv.mkDerivation rec {
  version = "0.2.2";
  name = "zathura-pdf-poppler-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "0px59f0bnmb9992n3c9iyzcwd6w7vg8ga069vc8qj4726ljml4c7";
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
