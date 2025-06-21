{
  buildNpmPackage,
  lib,
  stdenv,
  fetchFromGitHub,
  chromium,
  nix-update-script,
}:
let
  version = "11.4.3";
in
buildNpmPackage {
  pname = "mermaid-cli";
  version = version;

  src = fetchFromGitHub {
    owner = "mermaid-js";
    repo = "mermaid-cli";
    rev = version;
    hash = "sha256-vf6FwQlgSvbOL+areHrAI0MnsfXg/7lC6PZTyFfOE78=";
  };

  patches = [
    ./remove-puppeteer-from-dev-deps.patch # https://github.com/mermaid-js/mermaid-cli/issues/830
  ];

  npmDepsHash = "sha256-+X3WJalbcCt1dClp8DcbvtfdYS4DFxZW6TgQMddLXFc=";

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
