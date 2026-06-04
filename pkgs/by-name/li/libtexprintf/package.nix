{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:
stdenv.mkDerivation {
  pname = "libtexprintf";
  version = "1.31+1897783";

  src = fetchFromGitHub {
    owner = "bartp5";
    repo = "libtexprintf";
    rev = "18977837b20649d56a651eb6bf846f1c914db77a";
    hash = "sha256-OXDcohfSfik0H1MpoznN267OVTYkW75N+TIF6lRRvZ0=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  preCheck = ''
    patchShebangs .
  '';

  doCheck = true;

  outputs = [
    "out"
    "dev"
    "man"
  ];

  meta = {
    description = "Library providing printf-style formatted output routines with tex-like syntax support";
    homepage = "https://github.com/bartp5/libtexprintf";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.seudonym ];
    platforms = lib.platforms.unix;
    mainProgram = "utftex";
  };
}
