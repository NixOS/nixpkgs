{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libuchardet,
  pkg-config,
  faac,
  flac,
  opus-tools,
  vorbis-tools,
  mp3gain,
  lame,
  taglib,
  wavpack,
  vorbisgain,
  monkeys-audio,
  sox,
  gtk3,
  qt6,
  ttaenc,
  withFaac ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flacon";
  version = "13.0.2";

  src = fetchFromGitHub {
    owner = "flacon";
    repo = "flacon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7UcZJ/npoAYRUUYUUkq/TisCDWShWcjalXACwCOsOmc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    qt6.qtbase
    qt6.qttools
    libuchardet
    taglib
  ];

  bin_path = lib.makeBinPath (
    [
      flac
      opus-tools
      vorbis-tools
      mp3gain
      lame
      ttaenc
      wavpack
      monkeys-audio
      vorbisgain
      sox
    ]
    ++ lib.optional withFaac faac
  );

  qtWrapperArgs = [
    "--suffix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/${gtk3.name}"
    "--prefix PATH : ${finalAttrs.bin_path}"
  ];

  meta = {
    description = "Extracts audio tracks from an audio CD image to separate tracks";
    longDescription = ''
      Flacon extracts individual tracks from one big audio file containing the
      entire album of music and saves them as separate audio files. To do this,
      it uses information from the appropriate CUE file. Besides, Flacon makes
      it possible to conveniently revise or specify tags both for all tracks
      at once or for each tag separately.

      Supported input formats: WAV, FLAC, APE, WavPack, True Audio (TTA)
      Supported output formats: FLAC, WAV, WavPack, AAC, OGG or MP3
    '';
    mainProgram = "flacon";
    homepage = "https://flacon.github.io/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ snglth ];
  };
})
