{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  yarn-berry_4,
}:

let
  yarn-berry = yarn-berry_4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "napi-rs-cli";
  version = "3.7.4";

  src = fetchFromGitHub {
    owner = "napi-rs";
    repo = "napi-rs";
    tag = "@napi-rs/cli@${finalAttrs.version}";
    hash = "sha256-FxVRaWbpRNcpiGWW7c76fyvoHBKIslUuveEjh4Kldr8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  missingHashes = ./missing-hashes.json;

  yarnOfflineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-6w1eIE+akL+04CwTAc4gCWBWu47E5J6dj+tIWp5glGk=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  # Don't run native module build scripts - the CLI doesn't need them
  env.YARN_ENABLE_SCRIPTS = "0";

  buildPhase = ''
    runHook preBuild

    yarn workspace @napi-rs/cli build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib/napi-rs-cli"

    cp -r cli/dist "$out/lib/napi-rs-cli"
    cp -r node_modules "$out/lib/napi-rs-cli"

    # Remove workspace symlinks that point to non-existent paths
    find "$out/lib/napi-rs-cli/node_modules" -type l ! -exec test -e {} \; -delete

    makeWrapper ${lib.getExe nodejs} "$out/bin/napi" \
      --add-flags "$out/lib/napi-rs-cli/dist/cli.js" \
      --set NODE_PATH "$out/lib/napi-rs-cli/node_modules"

    runHook postInstall
  '';

  meta = {
    description = "CLI tools for napi-rs";
    mainProgram = "napi";
    homepage = "https://napi.rs";
    changelog = "https://napi.rs/changelog/napi-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      winter
      martinjlowm
    ];
    inherit (nodejs.meta) platforms;
  };
})
