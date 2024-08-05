{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "cross-seed";
  version = "6.0.0-24";

  src = fetchFromGitHub {
    owner = "cross-seed";
    repo = "cross-seed";
    rev = "v${version}";
    hash = "sha256-2q3Q5QFpZP4yyX5+LlVOQXwbKdli4i/Lf+cITOZQkmE=";
  };

  npmDepsHash = "sha256-xu3V8csBO39ZYEQ/YibrUHryPuHtVxyXR5AEAVGphGo=";

  meta = {
    description = "Fully-automatic cross-seeding with Torznab";
    homepage = "https://cross-seed.org";
    license = lib.licenses.asl20;
    mainProgram = "cross-seed";
    maintainers = with lib.maintainers; [ mkez ];
  };
}
