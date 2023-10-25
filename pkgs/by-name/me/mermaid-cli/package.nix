{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, nodejs
, prefetch-yarn-deps
, yarn
, chromium
}:

stdenv.mkDerivation rec {
  pname = "mermaid-cli";
  version = "10.4.0";

  src = fetchFromGitHub {
    owner = "mermaid-js";
    repo = "mermaid-cli";
    rev = version;
    hash = "sha256-mzBN/Hg/03+jYyoAHvjx33HC46ZA6dtHmiSnaExCRR0=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-RQsRGzkuPgGVuEpF5lzv26XKMPLX2NrsjVkGMMkCbO4=";
  };

  nativeBuildInputs  = [
    makeWrapper
    nodejs
    prefetch-yarn-deps
    yarn
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline prepare

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    mkdir -p "$out/lib/node_modules/@mermaid-js/mermaid-cli"
    cp -r . "$out/lib/node_modules/@mermaid-js/mermaid-cli"

    makeWrapper "${nodejs}/bin/node" "$out/bin/mmdc" \
  '' + lib.optionalString (lib.meta.availableOn stdenv.targetPlatform chromium) ''
      --set PUPPETEER_EXECUTABLE_PATH '${lib.getExe chromium}' \
  '' + ''
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
