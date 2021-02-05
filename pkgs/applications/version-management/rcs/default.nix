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

  doCheck = !stdenv.isDarwin;

  checkFlags = [ "VERBOSE=1" ];

  checkPhase = ''
    # If neither LOGNAME or USER are set, rcs will default to
    # getlogin(), which is unreliable on macOS. It will often return
    # things like `_spotlight`, or `_mbsetupuser`. macOS sets both
    # environment variables in user sessions, so this is unlikely to
    # affect regular usage.

    export LOGNAME=$(id -un)

    print_logs_and_fail() {
      grep -nH -e . -r tests/*.d/{out,err}
      return 1
    }

    make $checkFlags check || print_logs_and_fail
  '';

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
