{
  lib,
  julec,
  clangStdenv,
  fetchFromGitHub,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "juledoc";
  version = "0.0.0-unstable-2026-02-02";

  src = fetchFromGitHub {
    owner = "julelang";
    repo = "juledoc";
    rev = "e01e200293d134064c674f705c9babf6d23775e8";
    hash = "sha256-JzIwIEd9kuVrBVo2H5bv3ROqpVUndBqLAZVYmoGbYuQ=";
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
