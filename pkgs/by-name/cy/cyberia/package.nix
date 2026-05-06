{
  rustPlatform,
  fetchgit,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  lib,
  stdenv,
  wrapGAppsHook4,
  dbus,
  glib-networking,
  gtk3,
  webkitgtk_4_1,
  alsa-lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cyberia";
  version = "0.2.3";

  __structuredAttrs = true;

  src = fetchgit {
    url = "https://git.gay/zutyosh/Cyberia.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-REcp7rl3nDzgqaBBjbC+LN+WMKLdfyn3nn9Jvypo7Ps=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-FrYDjydBsW1nYc3xsiR5jaPDm4eRwoOb1DK6XOMyiLU=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-BUoR/+5gARwZndh7YYp7vA/InWkn30yF9kR6PXsITBo=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook

    nodejs
    npmHooks.npmConfigHook

    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = [
    dbus
    gtk3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    webkitgtk_4_1
    alsa-lib
  ];

  meta = {
    description = "VRCX style client for Resonite";
    homepage = "https://git.gay/zutyosh/Cyberia";
    changelog = "https://git.gay/zutyosh/Cyberia/releases/tag/v${finalAttrs.version}";
    mainProgram = "cyberia";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toasteruwu ];
  };
})
