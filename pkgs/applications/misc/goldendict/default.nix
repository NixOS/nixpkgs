{ lib, stdenv, mkDerivation, fetchFromGitHub, pkg-config
, libXtst, libvorbis, hunspell, lzo, xz, bzip2, libiconv
, qtbase, qtsvg, qtwebkit, qtx11extras, qttools, qmake
, withCC ? true, opencc
, withEpwing ? true, libeb
, withExtraTiff ? true, libtiff
, withFFmpeg ? true, libao, ffmpeg
, withMultimedia ? true
, withZim ? true, zstd }:

mkDerivation rec {
  pname = "goldendict";
  version = "2021-03-09";

  src = fetchFromGitHub {
    owner = "goldendict";
    repo = pname;
    rev = "b2e673961d28ca5eb920a909091252d3321f09d6";
    sha256 = "sha256-+AAamnICq0/B54ggFpgF/Uupm1a4YiEYgHXrhIK4M0E=";
  };

  patches = [
    ./0001-dont-check-for-updates.patch
  ] ++ lib.optionals stdenv.isDarwin [
    ./0001-dont-use-maclibs.patch
  ];

  postPatch = ''
    substituteInPlace goldendict.pro \
      --replace "hunspell-1.6.1" "hunspell-${lib.versions.majorMinor hunspell.version}"
  '';

  nativeBuildInputs = [ pkg-config qmake ];
  buildInputs = [
    qtbase qtsvg qtwebkit qttools
    libvorbis hunspell xz lzo
  ] ++ lib.optionals stdenv.isLinux [ qtx11extras libXtst ]
    ++ lib.optionals stdenv.isDarwin [ bzip2 libiconv ]
    ++ lib.optional withCC opencc
    ++ lib.optional withEpwing libeb
    ++ lib.optional withExtraTiff libtiff
    ++ lib.optionals withFFmpeg [ libao ffmpeg ]
    ++ lib.optional withZim zstd;

  qmakeFlags = with lib; [
    "goldendict.pro"
    (optional withCC "CONFIG+=chinese_conversion_support")
    (optional (!withCC) "CONFIG+=no_chinese_conversion_support")
    (optional (!withEpwing) "CONFIG+=no_epwing_support")
    (optional (!withExtraTiff) "CONFIG+=no_extra_tiff_handler")
    (optional (!withFFmpeg) "CONFIG+=no_ffmpeg_player")
    (optional (!withMultimedia)"CONFIG+=no_qtmultimedia_player")
    (optional withZim "CONFIG+=zim_support")
  ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv GoldenDict.app $out/Applications
  '';

  meta = with lib; {
    homepage = "http://goldendict.org/";
    description = "A feature-rich dictionary lookup program";
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ gebner astsmtl sikmir ];
    license = licenses.gpl3Plus;
  };
}
