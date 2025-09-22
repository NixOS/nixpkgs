{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "getopt";
  version = "1.1.6";
  src = fetchurl {
    url = "http://frodo.looijaard.name/system/files/software/getopt/getopt-${version}.tar.gz";
    sha256 = "1zn5kp8ar853rin0ay2j3p17blxy16agpp8wi8wfg4x98b31vgyh";
  };

  # This should be fine on Linux and Darwin. Clang 16 requires it because otherwise getopt will
  # attempt to use C library functions without declaring them, which is raised as an error.
  env.NIX_CFLAGS_COMPILE = "-D__GNU_LIBRARY__";

  makeFlags = [
    "WITHOUT_GETTEXT=1"
    "LIBCGETOPT=0"
    "prefix=${placeholder "out"}"
    "CC:=$(CC)"
  ];

  meta = {
    platforms = lib.platforms.unix;
    homepage = "http://frodo.looijaard.name/project/getopt";
    description = "Parses command-line arguments from shell scripts";
    mainProgram = "getopt";
  };
}
