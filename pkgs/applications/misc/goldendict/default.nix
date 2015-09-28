{ stdenv, fetchFromGitHub, pkgconfig, qt4, libXtst, libvorbis, hunspell, libao, ffmpeg, libeb, lzo, xz, libtiff }:
stdenv.mkDerivation rec {
  name = "goldendict-1.5.0.20150801";
  src = fetchFromGitHub {
    owner = "goldendict";
    repo = "goldendict";
    rev = "b4bb1e9635c764aa602fbeaeee661f35e461d062";
    sha256 = "0dhaa0nii226541al3i2d8x8h7cfh96w5vkw3pa3l74llgrj7yx2";
  };

  buildInputs = [ pkgconfig qt4 libXtst libvorbis hunspell libao ffmpeg libeb lzo xz libtiff ];
  configurePhase = ''
    qmake PREFIX=$out 'CONFIG+=zim_support'
  '';

  meta = {
    homepage = http://goldendict.org/;
    description = "a feature-rich dictionary lookup program";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.astsmtl ];
  };
}
