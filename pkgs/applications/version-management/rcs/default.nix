{ lib, stdenv, fetchurl, buildPackages, diffutils, ed, lzip }:

stdenv.mkDerivation rec {
  pname = "rcs";
  version = "5.10.1";

  src = fetchurl {
    url = "mirror://gnu/rcs/${pname}-${version}.tar.lz";
    sha256 = "sha256-Q93+EHJKi4XiRo9kA7YABzcYbwHmDgvWL95p2EIjTMU=";
  };

  ac_cv_path_ED = "${ed}/bin/ed";
  DIFF = "${diffutils}/bin/diff";
  DIFF3 = "${diffutils}/bin/diff3";

  disallowedReferences =
    lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform)
      [ buildPackages.diffutils buildPackages.ed ];

  env.NIX_CFLAGS_COMPILE = "-std=c99";

  hardeningDisable = lib.optional stdenv.cc.isClang "format";

  nativeBuildInputs = [ lzip ];

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
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
