{ stdenv
, lib
, fetchFromGitHub
, pkg-config
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
  version = "unstable-2021-04-05";

  src = fetchFromGitHub {
    owner = "91861";
    repo = pname;
    rev = "e72ca78ef72c7b1e92473a98d435a3c85d7eab98";
    hash = "sha256-UXAVSfVpk/8KSg4oMw2tVWImD6HqJ7gEioR2MqhUUoQ=";
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

  # This patch forces the Makefile to use utf8proc
  # The makefile relies on ldconfig to find the utf8proc libraries
  # which is not possible on nixpkgs
  patches = [ ./utf8proc.patch ];

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

  meta = with lib; {
    description = "A simple terminal emulator";
    mainProgram = "wayst";
    homepage = "https://github.com/91861/wayst";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ berbiche ];
  };
}
