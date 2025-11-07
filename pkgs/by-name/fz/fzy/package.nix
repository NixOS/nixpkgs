{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "fzy";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "jhawthorn";
    repo = "fzy";
    rev = version;
    sha256 = "sha256-ZGAt8rW21WFGuf/nE44ZrL68L/RmTYCBzuXWhidqJB8=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Better fuzzy finder";
    homepage = "https://github.com/jhawthorn/fzy";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
    mainProgram = "fzy";
  };
}
