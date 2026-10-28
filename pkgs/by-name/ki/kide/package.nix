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
  wrapGAppsHook4,
  openssl,
  webkitgtk_4_1,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kide";
  version = "1.0.40";

  src = fetchFromGitHub {
    owner = "openobserve";
    repo = "kide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lRkFPS+hkACj3CxWde4B7phHUMh+2643Jgd0Wt3nUSo=";
  };

  cargoHash = "sha256-/PdUaSW7YMFDgMFqA+7ePNPraPhMSNqFaONIEFubtNc=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-1BY2oEnpldl+m8hUg9bszAyR67M8ErbcNaNE676c9hU=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast and lightweight Kubernetes IDE";
    homepage = "https://github.com/openobserve/kide";
    changelog = "https://github.com/openobserve/kide/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    inherit (cargo-tauri.hook.meta) platforms;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "kide";
  };
})
