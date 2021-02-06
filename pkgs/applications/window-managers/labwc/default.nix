{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
, cairo
, glib
, libinput
, libxml2
, pandoc
, pango
, wayland
, wayland-protocols
, wlroots
, libxcb
, libxkbcommon
, xwayland
}:

stdenv.mkDerivation rec {
  pname = "labwc";
  version = "unstable-2021-01-12";

  src = fetchFromGitHub {
    owner = "johanmalm";
    repo = pname;
    rev = "2a7086d9f7367d4a81bce58a6f7fc6614bbfbdb3";
    sha256 = "ECwEbWkCjktNNtbLSCflOVlEyxkg4XTfRevq7+qQ2IA=";
  };

  nativeBuildInputs = [ pkg-config meson ninja pandoc ];
  buildInputs = [
    cairo
    glib
    libinput
    libxml2
    pango
    wayland
    wayland-protocols
    wlroots
    libxcb
    libxkbcommon
    xwayland
  ];

  mesonFlags = [ "-Dxwayland=enabled" ];

  meta = with lib; {
    homepage = "https://github.com/johanmalm/labwc";
    description = "Openbox alternative for Wayland";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: report a SIGSEGV when labwc starts inside a started Wayland window
