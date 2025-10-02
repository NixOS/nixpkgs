{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  flex,
  bison,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "myanon";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "ppomes";
    repo = "myanon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pbClzLj9b4ZsehjSXwJjPlxpT6tlKcsZfEEfXVstlnA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    flex
    bison
  ];

  meta = {
    description = "mysqldump anonymizer, reading a dump from stdin, and producing on the fly an anonymized version to stdout";
    homepage = "https://ppomes.github.io/myanon/";
    license = lib.licenses.bsd3;
    mainProgram = "myanon";
    platforms = lib.platforms.unix;
  };
})
