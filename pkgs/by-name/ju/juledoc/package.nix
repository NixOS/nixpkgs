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
    rev = "d6ba549aeb82ea224e2cf07e0f0f3a2448dbd9db";
    hash = "sha256-3n9VOoXIFEI9V6fzSD75PdwkijXruC7qWClOUlWd52I=";
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
