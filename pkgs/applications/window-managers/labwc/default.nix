{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "0.2.1"; # We're effectively using that version

  src = fetchFromGitHub {
    owner = "johanmalm";
    repo = pname;
    rev = "6744e103014bcb0480133a029ec0f82f9b017e60";
    sha256 = "0sdr4zkix8x3vmna4i946y3whpj7fqizpaac6yj7w0as9d6hj0iq";
  };

  patches = [
    # To fix the build with wlroots 0.14:
    (fetchpatch {
      # output: access texture width/height directly
      url = "https://github.com/johanmalm/labwc/commit/892e93dd84c514b4e6f34a0fab01c727edd2d8de.patch";
      sha256 = "1p1pg1kd98727wlcspa2sffl7ijhvsfad6bj2rxsw322q0bz3yrh";
    })
    (fetchpatch {
      # xdg: chase swaywm/wlroots@9e58301
      url = "https://github.com/johanmalm/labwc/commit/874cc9e63706dd54d9f9fcb071f2d2e0c19d3d7e.patch";
      sha256 = "0ypd47q5ffq4wjkrcr3068qjknn2s66zszyxg3dl0f87q2pxh6wx";
    })
  ];

  nativeBuildInputs = [ pkg-config meson ninja scdoc ];
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
    libdrm
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
