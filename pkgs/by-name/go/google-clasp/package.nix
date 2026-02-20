{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "clasp";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "clasp";
    tag = "v${version}";
    hash = "sha256-JLfkGxUHvde5RXlIWH+raBvTwqvpHOR/ul4yArLFj28=";
  };

  npmDepsHash = "sha256-dT0HA21wvU+wP5/9juMYinY60Fq5ngWl5dgj0JJi9hM=";

  # `npm run build` tries installing clasp globally
  npmBuildScript = [ "compile" ];

  meta = {
    description = "Develop Apps Script Projects locally";
    mainProgram = "clasp";
    homepage = "https://github.com/google/clasp#readme";
    changelog = "https://github.com/google/clasp/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
