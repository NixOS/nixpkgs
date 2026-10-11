{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openpam";
  version = "20250531";

  src = fetchurl {
    url = "mirror://sourceforge/openpam/openpam/Ximenia/openpam-${finalAttrs.version}.tar.gz";
    hash = "sha256-wesvNpiwElgg2Y3b5WmqbUeNeWuLQlkLEa4A8+cgFZU=";
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
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
})
