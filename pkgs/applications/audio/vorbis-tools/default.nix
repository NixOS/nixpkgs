{stdenv, fetchurl, libogg, libvorbis, libao, pkgconfig, curl, glibc
, speex, flac}:

stdenv.mkDerivation {
  name = "vorbis-tools-1.1.1";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.1.1.tar.gz;
    sha256 = "617b4aa69e600c215b34fa3fd5764bc1d9d205d9d7d9fe7812bde7ec956fcaad";
  };

  # FIXME: Vorbis-tools expects `libOggFLAC', but this library was
  # merged with `libFLAC' as of FLAC 1.1.3.
  buildInputs = [ libogg libvorbis libao pkgconfig curl speex glibc flac ];

  patches = [ ./ogg123-curlopt-mute.patch ];

  meta = {
    longDescription = ''
      A set of command-line tools to manipulate Ogg Vorbis audio
      files, notably the `ogg123' player and the `oggenc' encoder.
    '';
    homepage = http://xiph.org/vorbis/;
    license = "GPLv2";
  };
}
