{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig
, libXtst, libvorbis, hunspell, lzo, xz, bzip2, libiconv
, qtbase, qtsvg, qtwebkit, qtx11extras, qttools, qmake
, withCC ? true, opencc
, withEpwing ? true, libeb
, withExtraTiff ? true, libtiff
, withFFmpeg ? true, libao, ffmpeg
, withMultimedia ? true
, withZim ? true }:

mkDerivation rec {
  pname = "goldendict";
  version = "2020-01-09";

  src = fetchFromGitHub {
    owner = "goldendict";
    repo = pname;
    rev = "da197ff5cd0e7326124c9240a1853a0e8b1de439";
    sha256 = "0dlzwjh9wg4bzhhib71jycpp21qw762ww63a37dd50z1ymi61lxc";
  };

  patches = [
    ./0001-dont-check-for-updates.patch
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    ./0001-dont-use-maclibs.patch
  ];

  postPatch = ''
    substituteInPlace goldendict.pro \
      --replace "hunspell-1.6.1" "hunspell-${stdenv.lib.versions.majorMinor hunspell.version}"
  '';

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [
    qtbase qtsvg qtwebkit qttools
    libvorbis hunspell xz lzo
  ] ++ stdenv.lib.optionals stdenv.isLinux [ qtx11extras libXtst ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ bzip2 libiconv ]
    ++ stdenv.lib.optional withCC opencc
    ++ stdenv.lib.optional withEpwing libeb
    ++ stdenv.lib.optional withExtraTiff libtiff
    ++ stdenv.lib.optionals withFFmpeg [ libao ffmpeg ];

  qmakeFlags = with stdenv.lib; [
    "goldendict.pro"
    (optional withCC "CONFIG+=chinese_conversion_support")
    (optional (!withCC) "CONFIG+=no_chinese_conversion_support")
    (optional (!withEpwing) "CONFIG+=no_epwing_support")
    (optional (!withExtraTiff) "CONFIG+=no_extra_tiff_handler")
    (optional (!withFFmpeg) "CONFIG+=no_ffmpeg_player")
    (optional (!withMultimedia)"CONFIG+=no_qtmultimedia_player")
    (optional withZim "CONFIG+=zim_support")
  ];

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv GoldenDict.app $out/Applications
    wrapQtApp $out/Applications/GoldenDict.app/Contents/MacOS/GoldenDict
  '';

  meta = with stdenv.lib; {
    homepage = "http://goldendict.org/";
    description = "A feature-rich dictionary lookup program";
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ gebner astsmtl sikmir ];
    license = licenses.gpl3Plus;
  };
}
