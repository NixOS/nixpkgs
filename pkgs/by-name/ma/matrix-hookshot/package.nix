{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  makeWrapper,
  matrix-sdk-crypto-nodejs,
  yarnConfigHook,
  yarnInstallHook,
  cargo,
  rustPlatform,
  rustc,
  napi-rs-cli,
  pkg-config,
  nodejs,
  openssl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "matrix-hookshot";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-hookshot";
    tag = finalAttrs.version;
    hash = "sha256-jRLax1vqC0K3XvAWrH1J7nqtFioLr4n6Df9Kra/KKKU=";
  };

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-bxSeaJyQojfqIl/X4pjG+QRATKYKjsQhTQ3JOY/HDFQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-1eBiLZHGNJxXNCVavkKt0xckAD2cilOW2wNCtqJ8O4g=";
  };

  buildInputs = [ openssl ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    yarnConfigHook
    yarnInstallHook
    pkg-config
    cargo
    rustc
    napi-rs-cli
    makeWrapper
    nodejs
  ];

  preBuild = ''
    # We want nixpkgs' version of this instead
    rm -rf node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    cp -r ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs \
      node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    chmod -R a+rwx node_modules/@matrix-org/matrix-sdk-crypto-nodejs
  '';

  buildPhase = ''
    runHook preBuild

    yarn run build:app:rs --target ${stdenv.hostPlatform.rust.rustcTargetSpec}
    yarn run build:app:fix-defs
    yarn run build:app
    yarn run build:web

    runHook postBuild
  '';

  postInstall = ''
    makeWrapper '${lib.getExe nodejs}' "$out/bin/matrix-hookshot" --add-flags \
        "$out/lib/node_modules/matrix-hookshot/lib/App/BridgeApp.js"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/matrix-org/matrix-hookshot/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Bridge between Matrix and multiple project management services, such as GitHub, GitLab and JIRA";
    homepage = "https://matrix-org.github.io/matrix-hookshot/";
    mainProgram = "matrix-hookshot";
    maintainers = with lib.maintainers; [ chvp ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
})
