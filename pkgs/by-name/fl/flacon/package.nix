{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libuchardet,
  pkg-config,
  shntool,
  flac,
  opusTools,
  vorbis-tools,
  mp3gain,
  lame,
  taglib,
  wavpack,
  vorbisgain,
  monkeysAudio,
  sox,
  gtk3,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flacon";
  version = "12.0.0";

  src = fetchFromGitHub {
    owner = "flacon";
    repo = "flacon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r9SdQg6JTMoGxO2xUtkkBe5F5cajnsndZEq20BjJGuU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qttools
    libuchardet
    taglib
  ];

  bin_path = lib.makeBinPath [
    shntool
    flac
    opusTools
    vorbis-tools
    mp3gain
    lame
    wavpack
    monkeysAudio
    vorbisgain
    sox
  ];

  postInstall = ''
    wrapProgram $out/bin/flacon \
      --suffix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}" \
      --prefix PATH : "$bin_path";
  '';

  meta = {
    description = "Extracts audio tracks from an audio CD image to separate tracks";
    mainProgram = "flacon";
    homepage = "https://flacon.github.io/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ snglth ];
  };
})
