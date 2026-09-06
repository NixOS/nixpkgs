{
  lib,
  stdenv,
  fetchurl,
  fetchDebianPatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gputils";
  version = "1.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/gputils/gputils-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-j7iCCzHXwffHdhQcyzxPBvQK+RXaY3QSjXUtHu463fI=";
  };

  patches = [
    (fetchDebianPatch {
      pname = "gputils";
      version = "1.5.2";
      debianRevision = "2";
      patch = "01-use-stdbool.diff";
      hash = "sha256-YuQqWWKC5cntaok1J7hZUv6NX/Xv1mI6+K3if3Owkzc=";
    })
  ];

  meta = {
    homepage = "https://gputils.sourceforge.io";
    description = "Collection of tools for the Microchip (TM) PIC microcontrollers. It includes gpasm, gplink, and gplib";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ yorickvp ];
    platforms = lib.platforms.linux;
  };
})
