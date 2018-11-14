{ stdenv, fetchurl
, openssl, qt5, libGLU_combined, zlib, pkgconfig, libav
}:

stdenv.mkDerivation rec {
  name = "makemkv-${ver}";
  ver = "1.14.0";
  builder = ./builder.sh;

  src_bin = fetchurl {
    url = "http://www.makemkv.com/download/makemkv-bin-${ver}.tar.gz";
    sha256 = "1xm5pww6jf3m704y7d7nc2ni2a6ygxwb2c665agg2i059sppwz1f";
  };

  src_oss = fetchurl {
    url = "http://www.makemkv.com/download/makemkv-oss-${ver}.tar.gz";
    sha256 = "1ihma2nv7zgqx1psgj3bdz723h94f4vk8mbahxl1v4v2rn9kg25z";
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
