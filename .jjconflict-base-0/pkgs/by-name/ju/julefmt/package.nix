{
  lib,
  julec,
  clangStdenv,
  fetchFromGitHub,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "julefmt";
  version = "0.0.0-unstable-2026-05-02";

  src = fetchFromGitHub {
    owner = "julelang";
    repo = "julefmt";
    rev = "7ac9b383013d13a03bc06f90f0b86f4fca11a4a8";
    hash = "sha256-q90B0rYaUN/gQ3TUNcPS+SqIQefam1Qmzx6jUBe+c0g=";
  };

  nativeBuildInputs = [ julec.hook ];

  env.JULE_OUT_NAME = "julefmt";

  meta = {
    description = "Official formatter tool for the Jule programming language";
    homepage = "https://manual.jule.dev/tools/julefmt";
    license = lib.licenses.bsd3;
    mainProgram = "julefmt";
    inherit (julec.meta) platforms maintainers;
  };
})
