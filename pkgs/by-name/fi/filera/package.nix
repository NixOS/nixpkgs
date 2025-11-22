{
  lib,
  stdenvNoCC,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  glib-networking,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook4,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "filera";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "joncorv";
    repo = "filera";
    tag = "filera-v${finalAttrs.version}";
    hash = "sha256-T55F8R+WH38Q4lMPTakR4m7A9ELiJaIPTT4BR3p62cA=";
  };

  cargoHash = "sha256-7dQt1VEJC9Ia9FnL9wFsIqnqoUeaq8E3DayF9lG9kd8=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-p+AI4hsHjjG8kXDk4fOqKclMCWx7NA8Tyv5xhfHxExs=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    glib-networking
    openssl
    webkitgtk_4_1
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern file management application built with Tauri";
    homepage = "https://github.com/joncorv/filera";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ joncorv ];
    mainProgram = "filera";
    platforms = lib.platforms.linux;
  };
})
