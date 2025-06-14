{
  lib,
  fetchFromGitHub,
  stdenv,
  nodejs,
  yarn-berry_4,
  makeWrapper,
  fetchpatch2,
}:

let
  yarn-berry = yarn-berry_4;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "peacock";
  version = "8.1.0";

  patches = [
    # fix: sort contracts for deterministic build
    (fetchpatch2 {
      url = "https://github.com/thepeacockproject/Peacock/commit/9ce9c82a74429a7811c538c232b3171d5368db24.patch";
      hash = "sha256-O8uL5ZQSNeTZmtmKyKJ50TO4BrBUcblz2SKUO1YGmHc=";
    })
    # fix: serve webui relative to the current module
    (fetchpatch2 {
      url = "https://github.com/thepeacockproject/Peacock/commit/95e3de4554206197621315d00e863c00bf079ed7.patch";
      hash = "sha256-cwaspB1yJp7d9Wa8b/wQTpQ0EJhFbpRV2dxS69jFEOo=";
    })
    # fix: translate windows plugin paths on linux
    (fetchpatch2 {
      url = "https://github.com/thepeacockproject/Peacock/commit/073bdebea3c8fc7174d2b6865cc1c4e5c3568f79.patch";
      hash = "sha256-gxAzTMm+dhgYu+rpG+haaksmZGRpwtEU4R/A0jOkJCY=";
    })
  ];

  src = fetchFromGitHub {
    owner = "thepeacockproject";
    repo = "Peacock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oCUA8BU6FDDL85xk+l97RgWolShyJZGtQZWXskSCdPU=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry.yarnBerryConfigHook
    yarn-berry
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    yarn build
    yarn optimize

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    node chunk0.js noop

    # Keep more or less in sync with https://github.com/thepeacockproject/Peacock/blob/master/packaging/ciAssemble.sh
    # Not all output files are required.

    OUT_DIR="$out/share/peacock"
    mkdir -p "$OUT_DIR" "$out/bin"

    cp packaging/HOW_TO_USE.html "$OUT_DIR"
    cp PeacockPatcher.exe "$OUT_DIR"
    cp chunk*.js "$OUT_DIR"

    mkdir "$OUT_DIR"/resources
    cp resources/dynamic_resources_h3.rpkg "$OUT_DIR"/resources/dynamic_resources_h3.rpkg
    cp resources/dynamic_resources_h2.rpkg "$OUT_DIR"/resources/dynamic_resources_h2.rpkg
    cp resources/dynamic_resources_h1.rpkg "$OUT_DIR"/resources/dynamic_resources_h1.rpkg

    cp -r resources/challenges "$OUT_DIR"/resources/challenges
    cp -r resources/mastery "$OUT_DIR"/resources/mastery
    cp resources/contracts.prp "$OUT_DIR"/resources/contracts.prp
    mkdir "$OUT_DIR"/webui
    mkdir "$OUT_DIR"/webui/dist
    cp webui/dist/*.html "$OUT_DIR"/webui/dist
    cp -r webui/dist/assets "$OUT_DIR"/webui/dist/assets
    cp webui/dist/THIRDPARTYNOTICES.txt "$OUT_DIR"/webui/dist/THIRDPARTYNOTICES.txt
    cp options.ini "$OUT_DIR"

    makeWrapper ${lib.getExe nodejs} "$out/bin/peacock" \
      --add-flags "$OUT_DIR/chunk0.js"

    runHook postInstall
  '';

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-sB0oag0sheimho8pn25HSc8GMeuS1RTmHLZUPiSSDqE=";
  };

  meta = {
    description = "Server replacement for the HITMAN™ World of Assassination trilogy";
    homepage = "https://thepeacockproject.org/";
    changelog = "https://github.com/thepeacockproject/Peacock/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ marie ];
    mainProgram = "peacock";
    platforms = lib.platforms.linux;
  };
})
