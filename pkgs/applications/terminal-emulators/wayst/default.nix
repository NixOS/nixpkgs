{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, copyDesktopItems
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

stdenv.mkDerivation rec {
  pname = "wayst";
  version = "unstable-2023-07-16";

  src = fetchFromGitHub {
    owner = "91861";
    repo = pname;
    rev = "f8b218eec1af706fd5ae287f5073e6422eb8b6d8";
    hash = "sha256-tA2R6Snk5nqWkPXSbs7wmovWkT97xafdK0e/pKBUIUg=";
  };

  makeFlags = [ "INSTALL_DIR=\${out}/bin" ];

  nativeBuildInputs = [ pkg-config copyDesktopItems ];

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
  enableParallelBuilding = true;

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
    install -D icons/wayst.svg $out/share/icons/hicolor/scalable/apps/wayst.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Wayst";
      name = "wayst";
      genericName = "Terminal";
      exec = "wayst";
      icon = "wayst";
      categories = [ "System" "TerminalEmulator" ];
      keywords = [ "wayst" "terminal" ];
      comment = "A simple terminal emulator";
    })
  ];

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
