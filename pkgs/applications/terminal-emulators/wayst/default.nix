{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, nixosTests
, freetype
, fontconfig
, libGL
, libX11
, libXrandr
, libxcb
, libxkbcommon
, utf8proc
, wayland

, libnotify
, xdg-utils
, makeDesktopItem
}:

let
  desktopItem = makeDesktopItem {
    desktopName = "Wayst";
    name = "wayst";
    genericName = "Terminal";
    exec = "wayst";
    icon = "wayst";
    categories = [ "System" "TerminalEmulator" ];
    keywords = [ "wayst" "terminal" ];
    comment = "A simple terminal emulator";
  };
in
stdenv.mkDerivation rec {
  pname = "wayst";
<<<<<<< HEAD
  version = "unstable-2023-07-16";
=======
  version = "unstable-2021-04-05";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "91861";
    repo = pname;
<<<<<<< HEAD
    rev = "f8b218eec1af706fd5ae287f5073e6422eb8b6d8";
    hash = "sha256-tA2R6Snk5nqWkPXSbs7wmovWkT97xafdK0e/pKBUIUg=";
=======
    rev = "e72ca78ef72c7b1e92473a98d435a3c85d7eab98";
    hash = "sha256-UXAVSfVpk/8KSg4oMw2tVWImD6HqJ7gEioR2MqhUUoQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  makeFlags = [ "INSTALL_DIR=\${out}/bin" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fontconfig
    libX11
    freetype
    libGL
    libxcb
    libxkbcommon
    libXrandr
    utf8proc
    wayland
  ];
<<<<<<< HEAD
  enableParallelBuilding = true;
=======

  # This patch forces the Makefile to use utf8proc
  # The makefile relies on ldconfig to find the utf8proc libraries
  # which is not possible on nixpkgs
  patches = [ ./utf8proc.patch ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    substituteInPlace src/settings.c \
      --replace xdg-open ${xdg-utils}/bin/xdg-open
    substituteInPlace src/main.c \
      --replace notify-send ${libnotify}/bin/notify-send
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    install -D icons/wayst.svg $out/share/icons/hicolor/scalable/apps/wayst.svg
  '';

  passthru.tests.test = nixosTests.terminal-emulators.wayst;

  meta = with lib; {
    description = "A simple terminal emulator";
    mainProgram = "wayst";
    homepage = "https://github.com/91861/wayst";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ berbiche ];
  };
}
