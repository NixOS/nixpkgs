{stdenv, fetchurl, libogg, libvorbis, libao, pkgconfig, curl, glibc
, speex, flac}:

# FIXME: We'd need `libOggFLAC' too.

stdenv.mkDerivation {
  name = "vorbis-tools-1.1.1";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.1.1.tar.gz;
    sha256 = "617b4aa69e600c215b34fa3fd5764bc1d9d205d9d7d9fe7812bde7ec956fcaad";
  };

  buildInputs = [ libogg libvorbis libao pkgconfig curl speex flac glibc ];

  configureFlagsArray = [
    ("--with-curl=" + curl)
    ("--with-curl-libraries=" + curl + "/lib")
    ("--with-curl-includes=" + curl + "/include")
  ];

  meta = {
    description = ''A set of command-line tools to manipulate Ogg Vorbis
                    audio files, notably the `ogg123' player and the
		    `oggenc' encoder.'';
    homepage = http://xiph.org/vorbis/;
    license = "GPLv2";
  };
}
