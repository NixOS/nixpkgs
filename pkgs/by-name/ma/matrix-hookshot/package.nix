{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeWrapper,
  matrix-sdk-crypto-nodejs,
  pnpmConfigHook,
  cargo,
  pnpm_11,
  rustPlatform,
  rustc,
  aws-lc,
  napi-rs-cli,
  pkg-config,
  nodejs,
  openssl,
  nix-update-script,
}:

let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "matrix-hookshot";
  version = "7.6.2";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-hookshot";
    tag = finalAttrs.version;
    hash = "sha256-oWmVjwDl1TcCFzvN97xbnmmWuLUioKlzjBc9EC0srdg=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-KbXT3Ee7XTiiapVi1R4gBME0SGrP4gw8EQ4szahRV1Q=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-R2iAu0hF3AMr+oetLmiyWEHQOH9tTMZks11FyuOn5dI=";
  };

  buildInputs = [
    aws-lc
    openssl
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    pnpmConfigHook
    pnpm
    pkg-config
    cargo
    rustc
    napi-rs-cli
    makeWrapper
    nodejs
  ];

  patchPhase = ''
    runHook prePatch

    patchShebangs scripts/build-modules.sh

    runHook postPatch
  '';

  preBuild = ''
    rm -rf node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.6.6/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    cp -r ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs \
      node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.6.6/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    chmod -R a+rwx node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.6.6/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    rm -rf node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.7.0/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    cp -r ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs \
      node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.7.0/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    chmod -R a+rwx node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.7.0/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
  '';

  buildPhase = ''
    runHook preBuild

    pnpm run build:app:rs --target ${stdenv.hostPlatform.rust.rustcTargetSpec}
    pnpm run build:app
    pnpm run build:web
    pnpm run build:modules

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    rm -r ./node_modules
    pnpm install --production --offline --ignore-scripts --frozen-lockfile

    # Re-install matrix-sdk-crypto-nodejs
    rm -rf node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.6.6/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    cp -r ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs \
      node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.6.6/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    chmod -R a+rwx node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.6.6/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    rm -rf node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.7.0/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    cp -r ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs \
      node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.7.0/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    chmod -R a+rwx node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.7.0/node_modules/@matrix-org/matrix-sdk-crypto-nodejs

    mkdir -p $out/lib/node_modules/.pnpm/matrix-hookshot/
    mkdir $out/bin

    mv ./lib/* $out/lib/node_modules/.pnpm/matrix-hookshot
    mv ./public ./assets ./node_modules ./package.json $out/lib/node_modules/.pnpm/matrix-hookshot
    # Fix symlink broken by the above mv
    ln -sf $out/lib/node_modules/.pnpm/matrix-hookshot/public/modules/openproject/element-web \
      $out/lib/node_modules/.pnpm/matrix-hookshot/node_modules/.pnpm/node_modules/openproject-module

    runHook postInstall
  '';

  postInstall = ''
    makeWrapper '${lib.getExe nodejs}' "$out/bin/matrix-hookshot" \
      --set NODE_ENV "production" \
      --add-flags "$out/lib/node_modules/.pnpm/matrix-hookshot/App/BridgeApp.js"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/matrix-org/matrix-hookshot/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Bridge between Matrix and multiple project management services, such as GitHub, GitLab and JIRA";
    homepage = "https://matrix-org.github.io/matrix-hookshot/";
    mainProgram = "matrix-hookshot";
    maintainers = with lib.maintainers; [ chvp ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
