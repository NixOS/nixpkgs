{
  fetchzip,
  lib,
  stdenv,
  which,
}:

stdenv.mkDerivation rec {
  pname = "empty";
  version = "0.6.21b";

  src = fetchzip {
    url = "mirror://sourceforge/empty/empty/empty-${version}.tgz";
    sha256 = "1rkixh2byr70pdxrwr4lj1ckh191rjny1m5xbjsa7nqw1fw6c2xs";
    stripRoot = false;
  };

  patches = [
    ./0.6-Makefile.patch
  ];

  nativeBuildInputs = [ which ];

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    rm empty
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://empty.sourceforge.net";
    description = "Simple tool to automate interactive terminal applications";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    homepage = "https://empty.sourceforge.net";
    description = "Simple tool to automate interactive terminal applications";
    license = licenses.bsd3;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    longDescription = ''
      The empty utility provides an interface to execute and/or interact with
      processes under pseudo-terminal sessions (PTYs). This tool is definitely
      useful in programming of shell scripts designed to communicate with
      interactive programs like telnet, ssh, ftp, etc. In some cases empty can
      be the simplest replacement for TCL/expect or other similar programming
      tools because empty:

      - can be easily invoked directly from shell prompt or script
      - does not use TCL, Perl, PHP, Python or anything else as an underlying language
      - is written entirely in C
      - has small and simple source code
      - can easily be ported to almost all UNIX-like systems
    '';
<<<<<<< HEAD
    maintainers = [ lib.maintainers.djwf ];
=======
    maintainers = [ maintainers.djwf ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "empty";
  };
}
