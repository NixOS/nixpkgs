{ lib, stdenv, fetchurl, fetchpatch, buildPackages, diffutils, ed }:

stdenv.mkDerivation rec {
  pname = "rcs";
  version = "5.10.0";

  src = fetchurl {
    url = "mirror://gnu/rcs/${pname}-${version}.tar.xz";
    sha256 = "sha256-Og2flYx60wPkdehjRlSXTtvm3rOkVEkfOFfcGIm6xcU";
  };

  ac_cv_path_ED = "${ed}/bin/ed";
  DIFF = "${diffutils}/bin/diff";
  DIFF3 = "${diffutils}/bin/diff3";

  disallowedReferences =
    lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform)
      [ buildPackages.diffutils buildPackages.ed ];

  NIX_CFLAGS_COMPILE = "-std=c99";

  hardeningDisable = lib.optional stdenv.cc.isClang "format";

  meta = {
    homepage = "https://www.gnu.org/software/rcs/";
    description = "Revision control system";
    longDescription =
      '' The GNU Revision Control System (RCS) manages multiple revisions of
         files. RCS automates the storing, retrieval, logging,
         identification, and merging of revisions.  RCS is useful for text
         that is revised frequently, including source code, programs,
         documentation, graphics, papers, and form letters.
      '';

    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ eelco ];
    platforms = lib.platforms.unix;
  };
}
