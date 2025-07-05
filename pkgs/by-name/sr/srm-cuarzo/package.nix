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
  version = "0.13.0-1";
  rev = "v${self.version}";
  hash = "sha256-5BwLqAZdfO5vyEMPZImaxymvLoNuu6bOiOkvR8JERxg=";

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
