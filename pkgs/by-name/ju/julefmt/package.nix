{
  lib,
  julec,
  clangStdenv,
  fetchFromGitHub,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "julefmt";
  version = "0.0.0-unstable-2025-09-08";

  src = fetchFromGitHub {
    owner = "julelang";
    repo = "julefmt";
    rev = "cc30781206d3d7b88599cc51b3f9d7d7936de527";
    hash = "sha256-g3vN2Hz4BA5c0KqIbNKHg0W77xKGZQFHUIKWjg5/UTM=";
  };

  nativeBuildInputs = [ julec.hook ];

  JULE_OUT_NAME = "julefmt";

  meta = {
    description = "Official formatter tool for the Jule programming language";
    homepage = "https://manual.jule.dev/tools/julefmt";
    license = lib.licenses.bsd3;
    mainProgram = "julefmt";
    inherit (julec.meta) platforms maintainers;
  };
})
