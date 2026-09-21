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
  version = "7.4.4";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-hookshot";
    tag = finalAttrs.version;
    hash = "sha256-eF8a0v5sD3/pDrqFH1CRRTTqgUAoo3DAHXDl0b0KnXQ=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-PbWWJy4iWlEvCFRf8MV0K6ymynuMFvbK7bpQYDQIICE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-zlSAxkBA+IgyT09z8XSgvFjKRa5GGWltkexAvoNmYMk=";
  };

  buildInputs = [ openssl ];

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

  preBuild = ''
    # We want nixpkgs' version of this instead
    rm -rf node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.4.0/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    cp -r ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs \
      node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.4.0/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    chmod -R a+rwx node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.4.0/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
  '';

  buildPhase = ''
    runHook preBuild

    pnpm run build:app:rs --target ${stdenv.hostPlatform.rust.rustcTargetSpec}
    pnpm run build:app
    pnpm run build:web

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    rm -r ./node_modules
    pnpm install --production --offline --force --frozen-lockfile

    # Re-install matrix-sdk-crypto-nodejs
    rm -rf node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.4.0/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    cp -r ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs \
      node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.4.0/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    chmod -R a+rwx node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.4.0/node_modules/@matrix-org/matrix-sdk-crypto-nodejs

    mkdir -p $out/lib/node_modules/.pnpm/matrix-hookshot/
    mkdir $out/bin

    mv ./lib/* $out/lib/node_modules/.pnpm/matrix-hookshot
    mv ./public ./assets ./node_modules ./package.json $out/lib/node_modules/.pnpm/matrix-hookshot

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
