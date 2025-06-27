{
  buildNpmPackage,
  lib,
  stdenv,
  fetchFromGitHub,
  chromium,
  nix-update-script,
}:
let
  version = "11.6.0";
in
buildNpmPackage {
  pname = "mermaid-cli";
  version = version;

  src = fetchFromGitHub {
    owner = "mermaid-js";
    repo = "mermaid-cli";
    rev = version;
    hash = "sha256-9Ozi5mAeFVdwGMjvlLG4hMWnCGi552SsT5RuvRiF9ww=";
  };

  patches = [
    ./remove-puppeteer-from-dev-deps.patch # https://github.com/mermaid-js/mermaid-cli/issues/830
  ];

  npmDepsHash = "sha256-SHGYv/IwrCB02M8w5HsEsB7BwWVRFYNDYJFRDgG3a14=";

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
