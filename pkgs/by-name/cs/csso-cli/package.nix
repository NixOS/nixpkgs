{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "csso-cli";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "css";
    repo = "csso-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mP3Q+7JlgIfPLZsCtYSpTBdV4+tT5qiEeP6fB87Wxw8=";
  };

  npmDepsHash = "sha256-IKy4o/tcNo0Hy49aTKAoHhfsR3xUNFYeBuvSoZXh0UI=";

  dontNpmBuild = true;

  meta = {
    description = "Command line interface for CSSO, a CSS minifier with structural optimizations";
    homepage = "https://github.com/css/csso-cli";
    changelog = "https://github.com/css/csso-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "csso";
    maintainers = with lib.maintainers; [ ners ];
  };
})
