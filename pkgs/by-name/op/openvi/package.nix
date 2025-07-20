{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "openvi";
  version = "7.6.31";

  src = fetchFromGitHub {
    owner = "johnsonjh";
    repo = "OpenVi";
    rev = version;
    hash = "sha256-RqmulYHQFZmTHQAYgZmB8tAG6mSquNODmssfKB8YqDU=";
  };

  buildInputs = [
    ncurses
    perl
  ];

  makeFlags = [
    "PREFIX=$(out)"
    # command -p will yield command not found error
    "PAWK=awk"
    # silently fail the chown command
    "IUSGR=$(USER)"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/johnsonjh/OpenVi";
    description = "Portable OpenBSD vi for UNIX systems";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "ovi";
  };
}
