{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libdisplay-info,
  libdrm,
  libGL,
  libinput,
  libgbm,
  seatd,
  udev,
}:
stdenv.mkDerivation (self: {
  pname = "srm-cuarzo";
  version = "0.12.1-1";
  rev = "v${self.version}";
  hash = "sha256-zRj3KToMoIioY1Ez41XgFLzGIHV5bDX2aPEUsPsIkXM=";

  src = fetchFromGitHub {
    inherit (self) rev hash;
    owner = "CuarzoSoftware";
    repo = "SRM";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libdisplay-info
    libdrm
    libGL
    libinput
    libgbm
    seatd
    udev
  ];

  outputs = [
    "out"
    "dev"
  ];

  preConfigure = ''
    # The root meson.build file is in src/
    cd src
  '';

  meta = {
    description = "Simple Rendering Manager";
    homepage = "https://github.com/CuarzoSoftware/SRM";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
