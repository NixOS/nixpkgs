{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig
, libXtst, libvorbis, hunspell, lzo, xz, bzip2, libiconv
, qtbase, qtsvg, qtwebkit, qtx11extras, qttools, qmake
, withCC ? true, opencc
, withEpwing ? true, libeb
, withExtraTiff ? true, libtiff
, withFFmpeg ? true, libao, ffmpeg_3
, withMultimedia ? true
, withZim ? true, zstd }:

mkDerivation rec {
  pname = "goldendict";
  version = "2020-05-27";

  src = fetchFromGitHub {
    owner = "goldendict";
    repo = pname;
    rev = "ec40c1dcfde6df1dc7950443b46ae22c283b1e52";
    sha256 = "1zmnwwnpnrqfyf7vmmh38r95q2fl4cqzbkp69bcwkr0xc80wgyz7";
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
    ++ stdenv.lib.optionals withFFmpeg [ libao ffmpeg_3 ]
    ++ stdenv.lib.optional withZim zstd;

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
