{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hwdata";
  version = "0.398";

  src = fetchFromGitHub {
    owner = "vcrhonek";
    repo = "hwdata";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rHpXkltESdfBDZ/dySzPgoLPs3l5jyBfNFaZYlALfnk=";
  };

  doCheck = false; # this does build machine-specific checks (e.g. enumerates PCI bus)

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
