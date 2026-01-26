{
  lib,
  fetchFromGitHub,
  stdenv,
  nodejs,
  yarn-berry_4,
  makeWrapper,
}:

let
  yarn-berry = yarn-berry_4;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "peacock";
  version = "8.3.0";

  src = fetchFromGitHub {
    owner = "thepeacockproject";
    repo = "Peacock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AegJ5h2sxs8iheBLbIBwZXjjZLk5GdcDVLbF4ldcmZ0=";
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
