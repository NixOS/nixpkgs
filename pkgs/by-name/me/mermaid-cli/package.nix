{
  buildNpmPackage,
  lib,
  stdenv,
  fetchFromGitHub,
  chromium,
  nix-update-script,
}:
let
  version = "12.0.0";
in
buildNpmPackage {
  pname = "mermaid-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "mermaid-js";
    repo = "mermaid-cli";
    rev = version;
    hash = "sha256-8CPcwqWz7A91Qyp9fpObv1m7K8H6A0c8UULjj1XlB+c=";
  };

  patches = [
    ./remove-puppeteer-from-dev-deps.patch # https://github.com/mermaid-js/mermaid-cli/issues/830
  ];

  npmDepsHash = "sha256-Y1w7oMGDUU7fNFijbjNbnlhY9nEMSR7ilNC3RnlLMaU=";

  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  npmBuildScript = "prepare";

  makeWrapperArgs = lib.lists.optional (lib.meta.availableOn stdenv.hostPlatform chromium) "--set PUPPETEER_EXECUTABLE_PATH '${lib.getExe chromium}'";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Generation of diagrams from text in a similar manner as markdown";
    homepage = "https://github.com/mermaid-js/mermaid-cli";
    license = lib.licenses.mit;
    mainProgram = "mmdc";
    maintainers = with lib.maintainers; [ ysndr ];
    platforms = lib.platforms.all;
  };
}
