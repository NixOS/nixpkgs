{ stdenv, fetchFromGitHub, pkgconfig, qt4, qmake4Hook, libXtst, libvorbis, hunspell
, libao, ffmpeg, libeb, lzo, xz, libtiff }:
stdenv.mkDerivation rec {
  name = "goldendict-1.5.0.ec86515";
  src = fetchFromGitHub {
    owner = "goldendict";
    repo = "goldendict";
    rev = "ec865158f5b7116f629e4d451a39ee59093eefa5";
    sha256 = "070majwxbn15cy7sbgz7ljl8rkn7vcgkm10884v97csln7bfzwhr";
  };

  buildInputs = [
    pkgconfig qt4 libXtst libvorbis hunspell libao ffmpeg libeb
    lzo xz libtiff qmake4Hook
  ];

  qmakeFlags = [ "CONFIG+=zim_support" ];

  meta = {
    homepage = http://goldendict.org/;
    description = "a feature-rich dictionary lookup program";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.astsmtl ];
  };
}
