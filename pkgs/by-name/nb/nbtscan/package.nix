{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation {
  pname = "nbtscan";
  version = "1.7.2-unstable-2022-10-29";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = "nbtscan";
    rev = "e09e22a2a322ba74bb0b3cd596933fe2e31f4b2b";
    hash = "sha256-+AOubF6eZ1Zvk5n8mGl9TxEicBpS4kYThA4MrEaGjAs=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Scan networks searching for NetBIOS information";
    mainProgram = "nbtscan";
    homepage = "https://github.com/resurrecting-open-source-projects/nbtscan";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
