{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,
  openssl,
  webkitgtk_4_1,
  versionCheckHook,
  nix-update-script,
  gitMinimal,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gg";
  version = "0.39.1";

  src = fetchFromGitHub {
    owner = "gulbanana";
    repo = "gg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0f1MM9iXjYuj7Anu6TMVtAjo3fg0IeOyrKfpeODrvA8=";
  };

  cargoHash = "sha256-oDAA4lFfp/zMQ2gm595OgnNyP3tiPSC1M0hiozOH/ss=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    hash = "sha256-aZSBKEVftMfPuIOnwc/ykbjdmb3Np+gJl1Jq9yv4pck=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
  ];

  nativeCheckInputs = [
    # Failing tests: Could not execute the git process, found in the OS path 'git'
    gitMinimal
  ];
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Attempted to create a NULL object.
    "--skip=web::tests::integration_test"
  ];

  env.OPENSSL_NO_VENDOR = true;

  postInstall = lib.optionals stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin
    ln -s $out/Applications/gg.app/Contents/MacOS/gg $out/bin/gg
  '';

  # The generated Darwin bundle cannot be tested in the same way as a standalone Linux executable
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GUI for the version control system Jujutsu";
    homepage = "https://github.com/gulbanana/gg";
    changelog = "https://github.com/gulbanana/gg/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    inherit (cargo-tauri.hook.meta) platforms;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "gg";
  };
})
