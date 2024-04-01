{ lib
, stdenv
, fetchFromGitLab
, fftw
, liblo
, libsndfile
, makeDesktopItem
, portaudio
, qmake
, qtbase
, wrapQtAppsHook
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

  meta = with lib; {
    description = "A custom sample mashing app";
    mainProgram = "samplebrain";
    homepage = "https://thentrythis.org/projects/samplebrain";
    changelog = "https://gitlab.com/then-try-this/samplebrain/-/releases/v${version}_release";
    maintainers = with maintainers; [ mitchmindtree ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
