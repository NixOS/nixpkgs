{stdenv, fetchurl, libogg, libvorbis, libao, pkgconfig, curl, glibc
, speex, flac}:

stdenv.mkDerivation {
  name = "vorbis-tools-1.4.0";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz;
    sha256 = "1g12bnh5ah08v529y72kfdz5lhvy75iaz7f9jskyby23m9dkk2d3";
  };

  buildInputs = [ libogg libvorbis libao pkgconfig curl speex glibc flac ];

  meta = {
    longDescription = ''
      A set of command-line tools to manipulate Ogg Vorbis audio
      files, notably the `ogg123' player and the `oggenc' encoder.
    '';
    homepage = http://xiph.org/vorbis/;
    license = stdenv.lib.licenses.gpl2;
  };
}
