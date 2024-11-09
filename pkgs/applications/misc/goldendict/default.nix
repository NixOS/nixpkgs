{ lib, stdenv, fetchFromGitHub, pkg-config
, libXtst, libvorbis, hunspell, lzo, xz, bzip2, libiconv
, qtbase, qtsvg, qtwebkit, qtx11extras, qttools, qmake
, wrapQtAppsHook
, wrapGAppsHook3
, withCC ? true, opencc
, withEpwing ? true, libeb
, withExtraTiff ? true, libtiff
, withFFmpeg ? true, libao, ffmpeg
, withMultimedia ? true
, withZim ? true, zstd }:

stdenv.mkDerivation rec {
  pname = "goldendict";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "goldendict";
    repo = pname;
    rev = version;
    hash = "sha256-80o8y+mbzpyMQYUGHYs/zgQT23nLVCs7Jcr8FbbXn8M=";
  };

  patches = [
    ./0001-dont-check-for-updates.patch
    ./0001-dont-use-maclibs.patch
  ];

  postPatch = ''
    substituteInPlace goldendict.pro \
      --replace "hunspell-1.6.1" "hunspell-${lib.versions.majorMinor hunspell.version}" \
      --replace "opencc.2" "opencc"
  '';

  nativeBuildInputs = [ pkg-config qmake wrapQtAppsHook wrapGAppsHook3 ];
  buildInputs = [
    qtbase qtsvg qtwebkit qttools
    libvorbis hunspell xz lzo
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ qtx11extras libXtst ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ bzip2 libiconv ]
    ++ lib.optional withCC opencc
    ++ lib.optional withEpwing libeb
    ++ lib.optional withExtraTiff libtiff
    ++ lib.optionals withFFmpeg [ libao ffmpeg ]
    ++ lib.optional withZim zstd;

  qmakeFlags = [
    "goldendict.pro"
    (lib.optional withCC "CONFIG+=chinese_conversion_support")
    (lib.optional (!withCC) "CONFIG+=no_chinese_conversion_support")
    (lib.optional (!withEpwing) "CONFIG+=no_epwing_support")
    (lib.optional (!withExtraTiff) "CONFIG+=no_extra_tiff_handler")
    (lib.optional (!withFFmpeg) "CONFIG+=no_ffmpeg_player")
    (lib.optional (!withMultimedia)"CONFIG+=no_qtmultimedia_player")
    (lib.optional withZim "CONFIG+=zim_support")
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv GoldenDict.app $out/Applications
  '';

  meta = with lib; {
    homepage = "http://goldendict.org/";
    description = "Feature-rich dictionary lookup program";
    platforms = with platforms; linux ++ darwin;
    mainProgram = "goldendict";
    maintainers = with maintainers; [ gebner astsmtl sikmir ];
    license = licenses.gpl3Plus;
  };
}
