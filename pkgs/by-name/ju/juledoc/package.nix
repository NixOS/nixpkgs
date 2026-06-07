{
  lib,
  julec,
  clangStdenv,
  fetchFromGitHub,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "juledoc";
  version = "0.0.0-unstable-2026-04-13";

  src = fetchFromGitHub {
    owner = "julelang";
    repo = "juledoc";
    rev = "8504254a30d04a403c1b3ac788b62491233421e5";
    hash = "sha256-L8Oh2u35hraJYHimxJbBqro7iVh1a7MbVuqtujgb7c8=";
  };

  nativeBuildInputs = [ julec.hook ];

  env.JULE_OUT_NAME = "juledoc";

  meta = {
    description = "Official documentation generator for the Jule programming language";
    homepage = "https://manual.jule.dev/tools/juledoc";
    license = lib.licenses.bsd3;
    mainProgram = "juledoc";
    inherit (julec.meta) platforms maintainers;
  };
})
