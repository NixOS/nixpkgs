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
, pango
, wayland
, wayland-protocols
, wlroots
, libxcb
, libxkbcommon
, xwayland
, libdrm
, scdoc
}:

stdenv.mkDerivation rec {
  pname = "labwc";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = pname;
    rev = version;
    sha256 = "18vdmchkn7krm7c25cp80ispfc3gcg3559y8pdwyni6l3q6xbn1v";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];
  buildInputs = [
    cairo
    glib
    libdrm
    libinput
    libxcb
    libxkbcommon
    libxml2
    pango
    wayland
    wayland-protocols
    wlroots
    xwayland
  ];

  mesonFlags = [ "-Dxwayland=enabled" ];

  meta = with lib; {
    homepage = "https://github.com/labwc/labwc";
    description = "Openbox alternative for Wayland";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
