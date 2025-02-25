{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-01-02";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "66823c533a9b273293a18a342ffaea749218827b";
    hash = "sha256-EQGpHnIcvgNdp5rwJVxQRdJwRzBTMxZDSF1521ybZqI=";
  };

  makefile = "Makefile";
  preBuild = "cd src/os/libretro";
  dontConfigure = true;

  meta = {
    description = "Port of Stella to libretro";
    homepage = "https://github.com/stella-emu/stella";
    license = lib.licenses.gpl2Only;
  };
}
