{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "openvi";
  version = "7.3.22";

  src = fetchFromGitHub {
    owner = "johnsonjh";
    repo = "OpenVi";
    rev = version;
    hash = "sha256-yXYiH2FCT7ffRPmb28V54+KO1RLs8L9KHk3remkMWmA=";
  };

  patches = [
    # do not attempt to install to /var/tmp/vi.recover
    (fetchpatch {
      url = "https://github.com/johnsonjh/OpenVi/commit/5205f0234369963c443e83ca5028ca63feaaac91.patch";
      hash = "sha256-hoKzQLnpdRbc48wffWbzFtivr20VqEPs4WRPXuDa/88=";
    })
  ];

  buildInputs = [ ncurses ];

  makeFlags = [
    "PREFIX=$(out)"
    # command -p will yield command not found error
    "PAWK=awk"
    # silently fail the chown command
    "IUSGR=$(USER)"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/johnsonjh/OpenVi";
    description = "Portable OpenBSD vi for UNIX systems";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ aleksana ];
    mainProgram = "ovi";
  };
}
