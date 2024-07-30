{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, flex
, bison
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "myanon";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "ppomes";
    repo = "myanon";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-tTGr8bTxZc75GYhpJ0uzpkPtMB3r/DXRMNqSlG+1eaA=";
  };

  nativeBuildInputs = [ autoreconfHook flex bison ];

  meta = {
    description = "Myanon is a mysqldump anonymizer, reading a dump from stdin, and producing on the fly an anonymized version to stdout";
    homepage = "https://ppomes.github.io/myanon/";
    license = lib.licenses.bsd3;
    mainProgram = "myanon";
    platforms = lib.platforms.unix;
  };
})

