{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  fftw,
  liblo,
  libsndfile,
  makeDesktopItem,
  portaudio,
  qmake,
  qtbase,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "samplebrain";
  version = "0.18.5";

  src = fetchFromGitLab {
    owner = "then-try-this";
    repo = "samplebrain";
    rev = "v${version}_release";
    hash = "sha256-/pMHmwly5Dar7w/ZawvR3cWQHw385GQv/Wsl1E2w5p4=";
  };

  patches = [
    # Fixes build with recent liblo, see https://gitlab.com/then-try-this/samplebrain/-/merge_requests/16
    (fetchpatch {
      url = "https://gitlab.com/then-try-this/samplebrain/-/commit/032fd7c03931d1ca2d5c3d5e29901569aa2b2a86.patch";
      hash = "sha256-aaZJh/vx8fOqrJTuFzQ9+1mXvDQQXLy1k/2SwkMkVk4=";
    })
  ];

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    fftw
    liblo
    libsndfile
    portaudio
    qtbase
  ];

  desktopItem = makeDesktopItem {
    type = "Application";
    desktopName = pname;
    name = pname;
    comment = "A sample masher designed by Aphex Twin";
    exec = pname;
    icon = pname;
    categories = [ "Audio" ];
  };

  installPhase = ''
    mkdir -p $out/bin
    cp samplebrain $out/bin
    install -m 444 -D desktop/samplebrain.svg $out/share/icons/hicolor/scalable/apps/samplebrain.svg
  '';

  meta = {
    description = "Custom sample mashing app";
    mainProgram = "samplebrain";
    homepage = "https://thentrythis.org/projects/samplebrain";
    changelog = "https://gitlab.com/then-try-this/samplebrain/-/releases/v${version}_release";
    maintainers = with lib.maintainers; [ mitchmindtree ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
