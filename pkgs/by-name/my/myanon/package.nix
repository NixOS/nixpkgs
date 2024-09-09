{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, flex
, bison
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "myanon";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "ppomes";
    repo = "myanon";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-sB6ykRywaoG2gfHOEQ9UoVn62nMciBWgCM9DhovBoe0=";
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

