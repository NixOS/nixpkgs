{
  lib,
  fetchFromGitHub,
  rustPlatform,
  fetchPnpmDeps,
  pnpm_11,
  pnpmConfigHook,
  nodejs,
  aws-lc,
  openssl,
  zstd,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:
let
  pnpm = pnpm_11;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bichon";
  version = "2.4.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rustmailer";
    repo = "bichon";
    tag = finalAttrs.version;
    hash = "sha256-Wv7EBl6Wa0/v5dphHg9ba6uEtjWnf6YRwJdGGnGycl8=";
  };

  cargoHash = "sha256-YrF9EFOYZh8dBqMZNn5s8zCtq8iRI9+2AM0N8lMsnJ4=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    sourceRoot = "${finalAttrs.src.name}/web";
    fetcherVersion = 4;
    hash = "sha256-nKBz4WI0K/DyyIVAB6UEZDFn7OAM7WO21DEKJJMKLsE=";
  };
  pnpmRoot = "web";

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    pkg-config
  ];

  buildInputs = [
    aws-lc
    openssl
    zstd
  ];

  env.GIT_HASH = finalAttrs.src.rev;

  preBuild = ''
    # Build web frontend before rust build
    pushd web
    pnpm run build
    popd

    # Just sets the GIT_HASH variable for builds, we set it above so we don't need git
    rm crates/server/build.rs
  '';

  # The tests are flaky and some require the network
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  # `bichon-server` doesn't have a `--version` option but `bichon-cli` does.
  versionCheckProgram = "${placeholder "out"}/bin/bichon-cli";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/rustmailer/bichon/releases/tag/${finalAttrs.version}";
    description = "Lightweight, high-performance Rust email archiver with WebUI";
    homepage = "https://github.com/rustmailer/bichon";
    license = with lib.licenses; [ agpl3Only ];
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "bichon-server";
    platforms = lib.platforms.linux;
  };
})
