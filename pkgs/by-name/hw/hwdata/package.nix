{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hwdata";
  version = "0.412";

  src = fetchFromGitHub {
    owner = "vcrhonek";
    repo = "hwdata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kEFxNMFLg6UEEp3l7LP60y6uJbqbti/Ustu4crvMZMU=";
  };

  strictDeps = true;

  doCheck = false; # this does build machine-specific checks (e.g. enumerates PCI bus)

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/vcrhonek/hwdata";
    description = "Hardware Database, including Monitors, pci.ids, usb.ids, and video cards";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      johnrtitor
      pedrohlc
    ];
    platforms = lib.platforms.all;
  };
})
