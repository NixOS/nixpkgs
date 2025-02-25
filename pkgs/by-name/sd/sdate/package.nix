{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "sdate";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "ChristophBerg";
    repo = "sdate";
    rev = version;
    hash = "sha256-jkwe+bSBa0p1Xzfetsdpw0RYw/gSRxnY2jBOzC5HtJ8=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://www.df7cb.de/projects/sdate";
    description = "Eternal september version of the date program";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ edef ];
    platforms = platforms.all;
    mainProgram = "sdate";
  };
}
