{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "flux";
  version = "2013-09-20";

  src = fetchFromGitHub {
    owner = "deniskropp";
    repo = "flux";
    rev = "e45758aa9384b9740ff021ea952399fd113eb0e9";
    hash = "sha256-IJBDwrNc083/9lebkBGp72cfYJzmv5+MnAU3Dd71w4U=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    description = "Interface description language used by DirectFB";
    mainProgram = "fluxcomp";
    homepage = "https://github.com/deniskropp/flux";
    license = lib.licenses.mit;
  };
}
