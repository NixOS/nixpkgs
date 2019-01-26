{ stdenv, fetchFromGitHub, pkgconfig, libXtst, libvorbis, hunspell
, libao, ffmpeg, libeb, lzo, xz, libtiff
, qtbase, qtsvg, qtwebkit, qtx11extras, qttools, qmake }:
stdenv.mkDerivation rec {

  name = "goldendict-2018-06-13";
  src = fetchFromGitHub {
    owner = "goldendict";
    repo = "goldendict";
    rev = "48e850c7ec11d83cba7499f7fdce377ef3849bbb";
    sha256 = "0i4q4waqjv45hgwillvjik97pg26kwlmz4925djjkx8s6hxgjlq9";
  };

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [
    qtbase qtsvg qtwebkit qtx11extras qttools
    libXtst libvorbis hunspell libao ffmpeg libeb lzo xz libtiff
  ];

  qmakeFlags = [ "CONFIG+=zim_support" ];

  meta = with stdenv.lib; {
    homepage = http://goldendict.org/;
    description = "A feature-rich dictionary lookup program";
    platforms = platforms.linux;
    maintainers = with maintainers; [ gebner astsmtl ];
    license = licenses.gpl3Plus;
  };
}
