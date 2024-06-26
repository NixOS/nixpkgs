{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, fontconfig
, icu
, libdrm
, libGL
, libinput
, libX11
, libXcursor
, libxkbcommon
, mesa
, pixman
, seatd
, srm-cuarzo
, udev
, wayland
, xorgproto
}:
stdenv.mkDerivation (self: {
  pname = "louvre";
  version = "2.1.0-1";
  rev = "v${self.version}";
  hash = "sha256-qRvAryZ6SIhh5yDugcosVYOM2Tq0XPuaA6ib8/jWxNI=";

  src = fetchFromGitHub {
    inherit (self) rev hash;
    owner = "CuarzoSoftware";
    repo = "Louvre";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    fontconfig
    icu
    libdrm
    libGL
    libinput
    libX11
    libXcursor
    libxkbcommon
    mesa
    pixman
    seatd
    srm-cuarzo
    udev
    wayland
    xorgproto
  ];

  outputs = [ "out" "dev" ];

  preConfigure = ''
    # The root meson.build file is in src/
    cd src
  '';

  meta = {
    description = "C++ library for building Wayland compositors";
    homepage = "https://github.com/CuarzoSoftware/Louvre";
    mainProgram = "louvre-views";
    maintainers = [ lib.maintainers.dblsaiko ];
    platforms = lib.platforms.linux;
  };
})
