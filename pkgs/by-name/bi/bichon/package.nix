{
  lib,
  fetchFromGitHub,
  rustPlatform,
  fetchPnpmDeps,
  pnpm,
  pnpmConfigHook,
  nodejs,
  openssl,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bichon";
  version = "1.6.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rustmailer";
    repo = "bichon";
    tag = finalAttrs.version;
    hash = "sha256-a8BAO93eI2eiFwmvMqUsgL1KZ11X3qg/r/Iw6ckMSTs=";
  };

  cargoHash = "sha256-GC/2bswme76bAFRCsBHFi3lWnYx5x5H58emCmkiyKfE=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/web";
    fetcherVersion = 4;
    hash = "sha256-Ax8z1sjt8v6XOenhw7eRuEEo0huPv9fbcfzqc8RxJEc=";
  };
  pnpmRoot = "web";

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    pkg-config
  ];

  buildInputs = [
    openssl
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
