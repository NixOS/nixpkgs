{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastgron";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "adamritter";
    repo = "fastgron";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dAfFSQ/UbAovQQr5AnCsyQtq1JkdQjvlG/SbuFnTx0E=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ curl ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    changelog = "https://github.com/adamritter/fastgron/releases/tag/${finalAttrs.src.rev}";
    description = "High-performance JSON to GRON (greppable, flattened JSON) converter";
    mainProgram = "fastgron";
    homepage = "https://github.com/adamritter/fastgron";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zowoq ];
    platforms = lib.platforms.all;
  };
})
