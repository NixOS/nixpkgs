{ stdenv
, lib
, fetchFromGitHub
, nixosTests
, pkgconfig
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
, xdg_utils
, makeDesktopItem
}:

let
  desktopItem = makeDesktopItem {
    desktopName = "Wayst";
    name = "wayst";
    exec = "wayst";
    icon = "wayst";
    terminal = "false";
    categories = "System;TerminalEmulator";
    comment = "A simple terminal emulator";
    extraEntries = ''
      GenericName=Terminal
      Keywords=wayst;terminal;
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "wayst";
  version = "unstable-2020-10-12";

  src = fetchFromGitHub {
    owner = "91861";
    repo = pname;
    rev = "b8c7ca00a785a748026ed1ba08bf3d19916ced18";
    hash = "sha256-wHAU1yxukxApzhLLLctZ/AYqF7t21HQc5omPBZyxra0=";
  };

  makeFlags = [ "INSTALL_DIR=\${out}/bin" ];

  nativeBuildInputs = [ pkgconfig ];

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
      --replace xdg-open ${xdg_utils}/bin/xdg-open
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
    homepage = "https://github.com/91861/wayst";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ berbiche ];
  };
}
