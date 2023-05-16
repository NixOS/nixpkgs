<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, pkg-config
, libXtst, libvorbis, hunspell, lzo, xz, bzip2, libiconv
, qtbase, qtsvg, qtwebkit, qtx11extras, qttools, qmake
, wrapQtAppsHook
, wrapGAppsHook
=======
{ lib, stdenv, mkDerivation, fetchFromGitHub, pkg-config
, libXtst, libvorbis, hunspell, lzo, xz, bzip2, libiconv
, qtbase, qtsvg, qtwebkit, qtx11extras, qttools, qmake
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, withCC ? true, opencc
, withEpwing ? true, libeb
, withExtraTiff ? true, libtiff
, withFFmpeg ? true, libao, ffmpeg
, withMultimedia ? true
, withZim ? true, zstd }:

<<<<<<< HEAD
stdenv.mkDerivation rec {
  pname = "goldendict";
  version = "1.5.0";
=======
mkDerivation rec {
  pname = "goldendict";
  version = "2022-05-10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "goldendict";
    repo = pname;
<<<<<<< HEAD
    rev = version;
    hash = "sha256-80o8y+mbzpyMQYUGHYs/zgQT23nLVCs7Jcr8FbbXn8M=";
=======
    rev = "f810c6bd724e61977b4e94ca2d8abfa5bd766379";
    sha256 = "sha256-gNM+iahoGQy8TlNFLQx5ksITzQznv7MWMX/88QCTnL0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./0001-dont-check-for-updates.patch
<<<<<<< HEAD
=======
  ] ++ lib.optionals stdenv.isDarwin [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ./0001-dont-use-maclibs.patch
  ];

  postPatch = ''
    substituteInPlace goldendict.pro \
      --replace "hunspell-1.6.1" "hunspell-${lib.versions.majorMinor hunspell.version}" \
      --replace "opencc.2" "opencc"
  '';

<<<<<<< HEAD
  nativeBuildInputs = [ pkg-config qmake wrapQtAppsHook wrapGAppsHook ];
=======
  nativeBuildInputs = [ pkg-config qmake ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    mainProgram = "goldendict";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ gebner astsmtl sikmir ];
    license = licenses.gpl3Plus;
  };
}
