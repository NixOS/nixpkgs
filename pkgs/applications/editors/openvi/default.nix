{ lib
, stdenv
, fetchFromGitHub
, ncurses
, perl
}:

stdenv.mkDerivation rec {
  pname = "openvi";
  version = "7.5.28";

  src = fetchFromGitHub {
    owner = "johnsonjh";
    repo = "OpenVi";
    rev = version;
    hash = "sha256-6FP56tlPQXbphyJBDct5hBK81XsU6TJjKDZM4eHqitQ=";
  };

  buildInputs = [ ncurses perl ];

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
