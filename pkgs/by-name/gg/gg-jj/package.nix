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
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "gulbanana";
    repo = "gg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+jUO/b+Exr6kwK0igm8Rfg6r5hSUruLLCTjKL6sj09c=";
  };

  cargoHash = "sha256-qcsPZuFj+Pjf/llwjdJN49Avz+Vi/6sWEJOr5CHSIK0=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    hash = "sha256-c+dADG4Mrwup6iLu37Wg2jbltB3D3wLqqo4JxPclJUQ=";
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

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
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
    license = lib.licenses.asl20;
    inherit (cargo-tauri.hook.meta) platforms;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "gg";
  };
})
