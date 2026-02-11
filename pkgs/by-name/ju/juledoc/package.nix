{
  lib,
  julec,
  clangStdenv,
  fetchFromGitHub,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "juledoc";
  version = "0.0.0-unstable-2025-09-09";

  src = fetchFromGitHub {
    owner = "julelang";
    repo = "juledoc";
    rev = "3461147f4630104999bb895bdd8e60f40ca23aaf";
    hash = "sha256-0HuMWdoDoq2SgQhOnn6UnWXe2Js7/466cP2XpjvO5dw=";
  };

  nativeBuildInputs = [ julec.hook ];

  JULE_OUT_NAME = "juledoc";

  meta = {
    description = "Official documentation generator for the Jule programming language";
    homepage = "https://manual.jule.dev/tools/juledoc";
    license = lib.licenses.bsd3;
    mainProgram = "juledoc";
    inherit (julec.meta) platforms maintainers;
  };
})
