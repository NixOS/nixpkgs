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
    rev = "6bd55e31ebba393c973017332502a548ea0f402c";
    hash = "sha256-j8V5L4j4qaApJixsEo10Qv58IHcU54hnpL8uD+T0C0M=";
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
