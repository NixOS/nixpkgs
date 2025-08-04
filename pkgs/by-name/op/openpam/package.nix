{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openpam";
  version = "20230627";

  src = fetchurl {
    url = "mirror://sourceforge/openpam/openpam/Ximenia/openpam-${finalAttrs.version}.tar.gz";
    hash = "sha256-DZrI9bVaYkH1Bz8T7/HpVGFCLEWsGjBEXX4QaOkdtP0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  __structuredAttrs = true;

  meta = {
    homepage = "https://www.openpam.org";
    description = "Open source PAM library that focuses on simplicity, correctness, and cleanliness";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ matthewbauer ];
    license = lib.licenses.bsd3;
  };
})
