{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "extract-xiso";
  version = "202609111233";

  src = fetchFromGitHub {
    owner = "XboxDev";
    repo = "extract-xiso";
    tag = "build-${finalAttrs.version}";
    hash = "sha256-LvPSyCD8moyV3BLLuMWrXt83CIY/oNNGxoRLt836YIo=";
  };

  buildInputs = [ cmake ];

  doCheck = true;

  meta = {
    description = "Command line utility created by in to allow the creation, modification, and extraction of XISOs (Xbox ISOs)";
    homepage = "https://github.com/XboxDev/extract-xiso";
    license = lib.licenses.bsdOriginal;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      Marker06
    ];
  };

})
