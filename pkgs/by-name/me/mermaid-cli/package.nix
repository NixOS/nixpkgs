{
  buildNpmPackage,
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  chromium,
}:
let
  version = "11.4.2";
in
buildNpmPackage {
  pname = "mermaid-cli";
  version = version;

  src = fetchFromGitHub {
    owner = "mermaid-js";
    repo = "mermaid-cli";
    rev = version;
    hash = "sha256-hj6pnucms6OcLuIebnlHMQj2K8zMbyuWzvVkZh029Sw=";
  };

  patches = [
    ./integrity.patch # https://github.com/mermaid-js/mermaid-cli/issues/828
    ./remove-puppeteer-from-dev-deps.patch # https://github.com/mermaid-js/mermaid-cli/issues/830
  ];

  npmDepsHash = "sha256-lrj3lSCfqUfUFvtnJ/ELNUFE9kNTC4apnGrYxYmkUtE=";

  nativeBuildInputs = [
    makeWrapper
    nodejs
  ];

  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  npmBuildScript = "prepare";

  installPhase =
    ''
      runHook preInstall

      npm --omit=dev --include=peer --ignore-scripts install

      mkdir -p "$out/lib/node_modules/@mermaid-js/mermaid-cli"
      cp -r . "$out/lib/node_modules/@mermaid-js/mermaid-cli"

      makeWrapper "${nodejs}/bin/node" "$out/bin/mmdc" \
    ''
    + lib.optionalString (lib.meta.availableOn stdenv.hostPlatform chromium) ''
      --set PUPPETEER_EXECUTABLE_PATH '${lib.getExe chromium}' \
    ''
    + ''
        --add-flags "$out/lib/node_modules/@mermaid-js/mermaid-cli/src/cli.js"

      runHook postInstall
    '';

  meta = {
    description = "Generation of diagrams from text in a similar manner as markdown";
    homepage = "https://github.com/mermaid-js/mermaid-cli";
    license = lib.licenses.mit;
    mainProgram = "mmdc";
    maintainers = with lib.maintainers; [ ysndr ];
    platforms = lib.platforms.all;
  };
}
