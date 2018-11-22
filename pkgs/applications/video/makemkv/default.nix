{ stdenv, fetchurl
, openssl, qt5, libGLU_combined, zlib, pkgconfig, libav
}:

stdenv.mkDerivation rec {
  name = "makemkv-${ver}";
  ver = "1.14.1";
  builder = ./builder.sh;

  # Using two URLs as the first one will break as soon as a new version is released
  src_bin = fetchurl {
    urls = [
      "http://www.makemkv.com/download/makemkv-bin-${ver}.tar.gz"
      "http://www.makemkv.com/download/old/makemkv-bin-${ver}.tar.gz"
    ];
    sha256 = "1n4gjb1531gkvnjzipw63v3zdxmrq5nai9nn6m2ix3lskksjrrhp";
  };

  src_oss = fetchurl {
    urls = [
      "http://www.makemkv.com/download/makemkv-oss-${ver}.tar.gz"
      "http://www.makemkv.com/download/old/makemkv-oss-${ver}.tar.gz"
    ];
    sha256 = "0ysb0nm11vp2ni838p5q3gqan5nrqbr7rz0h24j8p62827pib3pw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [openssl qt5.qtbase libGLU_combined zlib libav];

  libPath = stdenv.lib.makeLibraryPath [stdenv.cc.cc openssl libGLU_combined qt5.qtbase zlib ]
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
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.titanous ];
  };
}
