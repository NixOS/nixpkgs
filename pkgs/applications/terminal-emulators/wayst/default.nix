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
  version = "unstable-2023-07-16";

  src = fetchFromGitHub {
    owner = "91861";
    repo = pname;
    rev = "f8b218eec1af706fd5ae287f5073e6422eb8b6d8";
    hash = "sha256-tA2R6Snk5nqWkPXSbs7wmovWkT97xafdK0e/pKBUIUg=";
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
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    install -D icons/wayst.svg $out/share/icons/hicolor/scalable/apps/wayst.svg
  '';

  passthru.tests.test = nixosTests.terminal-emulators.wayst;

  meta = with lib; {
    description = "Simple terminal emulator";
    mainProgram = "wayst";
    homepage = "https://github.com/91861/wayst";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ berbiche ];
  };
}
