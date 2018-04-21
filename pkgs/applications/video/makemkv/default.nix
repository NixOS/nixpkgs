{ stdenv, fetchurl
, openssl, qt4, libGLU_combined, zlib, pkgconfig, libav
}:

stdenv.mkDerivation rec {
  name = "makemkv-${ver}";
  ver = "1.10.8";
  builder = ./builder.sh;

  src_bin = fetchurl {
    url = "http://www.makemkv.com/download/makemkv-bin-${ver}.tar.gz";
    sha256 = "b7861aa7b03203f50d2ce3130f805c4b0406d13aec597648050349fa8b084b29";
  };

  src_oss = fetchurl {
    url = "http://www.makemkv.com/download/makemkv-oss-${ver}.tar.gz";
    sha256 = "d17cfd916a9bdda35b1065bce86a48a987caf9ffb4d6861609458f9f312603c7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [openssl qt4 libGLU_combined zlib libav];

  libPath = stdenv.lib.makeLibraryPath [stdenv.cc.cc openssl libGLU_combined qt4 zlib ]
          + ":" + stdenv.cc.cc + "/lib64";

  meta = with stdenv.lib; {
    description = "Convert blu-ray and dvd to mkv";
    longDescription = ''
      makemkv is a one-click QT application that transcodes an encrypted
      blu-ray or DVD disc into a more portable set of mkv files, preserving
      subtitles, chapter marks, all video and audio tracks.

      Program is time-limited -- it will stop functioning after 60 days. You
      can always download the latest version from makemkv.com that will reset the
      expiration date.
    '';
    license = licenses.unfree;
    homepage = http://makemkv.com;
    maintainers = [ maintainers.titanous ];
  };
}
