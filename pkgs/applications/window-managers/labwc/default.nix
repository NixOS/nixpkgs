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
  version = "unstable-2021-02-06";

  src = fetchFromGitHub {
    owner = "johanmalm";
    repo = pname;
    rev = "4a8fcf5c6d0b730b1e2e17e544ce7d7d3c72cd13";
    sha256 = "g1ba8dchUN393eis0VAu1bIjQfthDGLaSijSavz4lfU=";
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
