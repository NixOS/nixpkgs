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
  qtbase,
  qttools,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "flacon";
  version = "12.0.0";

  src = fetchFromGitHub {
    owner = "flacon";
    repo = "flacon";
    rev = "v${version}";
    sha256 = "sha256-r9SdQg6JTMoGxO2xUtkkBe5F5cajnsndZEq20BjJGuU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
    qttools
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

  meta = with lib; {
    description = "Extracts audio tracks from an audio CD image to separate tracks";
    mainProgram = "flacon";
    homepage = "https://flacon.github.io/";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ snglth ];
  };
}
