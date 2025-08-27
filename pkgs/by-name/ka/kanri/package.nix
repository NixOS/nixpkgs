{
  lib,
  stdenv,
  rustPlatform,
  fetchYarnDeps,
  fetchFromGitHub,
  cargo-tauri,
  glib-networking,
  yarnConfigHook,
  yarnBuildHook,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook4,
  nix-update-script,
  nodejs,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanri";
  version = "0.8.1";
  src = fetchFromGitHub {
    owner = "kanriapp";
    repo = "kanri";
    tag = "app-v${finalAttrs.version}";
    hash = "sha256-pP+q9AD2WATFYWHFitcrebN8y6iGCyXqmQYXCs9Ytf0=";
  };

  cargoHash = "sha256-JLv4YC40VcRMQVgJnunLkFIEfLKUTEDBgNMV6NmMAzA=";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-z0RLQ6n3hdsaBy3BiIOpuvpPBq3ST02r7lfsGfJypb8=";
  };

  nativeBuildInputs = [
    nodejs
    cargo-tauri.hook

    yarnConfigHook
    yarnBuildHook

    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook4
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    openssl
    webkitgtk_4_1
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  passthru.updateScript = nix-update-script { };

  preBuild = ''
    yarn --offline generate
  '';

  meta = {
    description = "Modern, minimalist Kanban board that works offline";
    homepage = "https://www.kanriapp.com/";
    license = lib.licenses.unfree;
    mainProgram = "kanri";
    maintainers = with lib.maintainers; [ miampf ];
  };
})
