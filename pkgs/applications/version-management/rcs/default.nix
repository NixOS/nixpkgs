{ stdenv, fetchurl, fetchpatch, ed }:

stdenv.mkDerivation rec {
  name = "rcs-5.9.4";

  src = fetchurl {
    url = "mirror://gnu/rcs/${name}.tar.xz";
    sha256 = "1zsx7bb0rgvvvisiy4zlixf56ay8wbd9qqqcp1a1g0m1gl6mlg86";
  };

  buildInputs = [ ed ];

  patches = stdenv.lib.optionals stdenv.isDarwin [
    # This failure appears unrelated to the subject of the test. This
    # test seems to rely on a bash bug where `test $x -nt $y` ignores
    # subsecond values in timetamps. This bug has been fixed in Bash
    # 5, and seemingly doesn't affect Darwin.
    ./disable-t810.patch

    (fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/b76d1e48dac/editors/nano/files/secure_snprintf.patch";
      extraPrefix = "";
      sha256 = "1wy9pjw3vvp8fv8a7pmkqmiapgacfx54qj9fvsc5gwry0vv7vnc3";
    })

    # Expected to appear in the next release
    (fetchpatch {
      url = "https://raw.githubusercontent.com/Homebrew/formula-patches/3fff7c990b8df4174045834b9c1210e7736ff5a4/rcs/noreturn.patch";
      sha256 = "10zniqrd6xagf3q03i1vksl0vd9nla3qcj0840n3m8z6jd4aypcx";
    })
  ];

  doCheck = true;

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

  hardeningDisable = stdenv.lib.optional stdenv.cc.isClang "format";

  meta = {
    homepage = https://www.gnu.org/software/rcs/;
    description = "Revision control system";
    longDescription =
      '' The GNU Revision Control System (RCS) manages multiple revisions of
         files. RCS automates the storing, retrieval, logging,
         identification, and merging of revisions.  RCS is useful for text
         that is revised frequently, including source code, programs,
         documentation, graphics, papers, and form letters.
      '';

    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ eelco ];
    platforms = stdenv.lib.platforms.unix;
  };
}
