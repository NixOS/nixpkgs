{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hwdata";
<<<<<<< HEAD
  version = "0.402";
=======
  version = "0.401";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "vcrhonek";
    repo = "hwdata";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-akLI2MdF6BDwvSoKt1jhlMyhKQv4TWxLFZWF7ivIezA=";
=======
    hash = "sha256-2NZwylrUfnzA0aE+xlVZ7QCpCzfW9DwGzRVHirt0TRU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
