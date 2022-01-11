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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "johanmalm";
    repo = pname;
    rev = version;
    sha256 = "sha256-v8LGiQG/n1IXeVMPWyiP9MgZzZLW78JftvxnRVTswaM=";
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
    homepage = "https://github.com/johanmalm/labwc";
    description = "Openbox alternative for Wayland";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
