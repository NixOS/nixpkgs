{
  lib,
  julec,
  clangStdenv,
  fetchFromGitHub,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "julefmt";
  version = "0.0.0-unstable-2026-01-31";

  src = fetchFromGitHub {
    owner = "julelang";
    repo = "julefmt";
    rev = "85b4aaca42e958fb33d6769879ec0a375913206c";
    hash = "sha256-1UR5hsG5squzb2ADPMmHMKFSL4/fePlYsSlfx70nPSU=";
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
