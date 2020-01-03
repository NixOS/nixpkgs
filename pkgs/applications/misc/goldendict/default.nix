{ mkDerivation, lib, fetchFromGitHub, pkgconfig, libXtst, libvorbis, hunspell
, libao, ffmpeg, libeb, lzo, xz, libtiff, opencc
, qtbase, qtsvg, qtwebkit, qtx11extras, qttools, qmake }:
mkDerivation {

  name = "goldendict-2019-08-01";
  src = fetchFromGitHub {
    owner = "goldendict";
    repo = "goldendict";
    rev = "0f951b06a55f3a201891cf645a556e773bda5f52";
    sha256 = "1d1hn95vhvsmbq9q96l5adn90g0hg25dl01knb4y4v6v9x4yrl2x";
  };

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [
    qtbase qtsvg qtwebkit qtx11extras qttools
    libXtst libvorbis hunspell libao ffmpeg libeb lzo xz libtiff opencc
  ];

  qmakeFlags = [
    "goldendict.pro"
    "CONFIG+=zim_support"
    "CONFIG+=chinese_conversion_support"
  ];

  meta = with lib; {
    homepage = http://goldendict.org/;
    description = "A feature-rich dictionary lookup program";
    platforms = platforms.linux;
    maintainers = with maintainers; [ gebner astsmtl ];
    license = licenses.gpl3Plus;
  };
}
