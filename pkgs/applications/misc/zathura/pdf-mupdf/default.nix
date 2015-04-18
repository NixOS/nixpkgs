{ stdenv, fetchurl, pkgconfig, zathura_core, gtk, girara, mupdf, openssl, openjpeg, libjpeg, jbig2dec }:

stdenv.mkDerivation rec {
  version = "0.2.7";
  name = "zathura-pdf-mupdf-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "0gr5kkk75hn7sz9kmzynhhcdd9xb9sz5gdb8p1iz9g0fjhskyd5i";
  };

  buildInputs = [ pkgconfig zathura_core gtk girara openssl mupdf openjpeg libjpeg jbig2dec ];

  makeFlags = "PREFIX=$(out) PLUGINDIR=$(out)/lib";

  preConfigure = "patch -p1 < ${./config.patch}";

  meta = {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A zathura PDF plugin (mupdf)";
    longDescription = ''
      The zathura-pdf-mupdf plugin adds PDF support to zathura by
      using the mupdf rendering library.
    '';
    license = stdenv.lib.licenses.zlib;
    platforms = stdenv.lib.platforms.linux;
#    maintainers = [ ];
  };
}
