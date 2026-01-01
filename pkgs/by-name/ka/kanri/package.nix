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
<<<<<<< HEAD
  version = "0.8.2";
=======
  version = "0.8.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "kanriapp";
    repo = "kanri";
    tag = "app-v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-HPwCU08cOkQre7ce9IxTbhwf3vi80VTpuLCoIT6b424=";
  };

  cargoHash = "sha256-efzchVrdjcfwLtRd87S4bK6Kqrfcdwthw1F0s557u/Y=";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-PBhn0VTt+6rf7YTuoVf3L4a6+AoXuad4E20dWiGVOOE=";
=======
    hash = "sha256-pP+q9AD2WATFYWHFitcrebN8y6iGCyXqmQYXCs9Ytf0=";
  };

  cargoHash = "sha256-JLv4YC40VcRMQVgJnunLkFIEfLKUTEDBgNMV6NmMAzA=";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-z0RLQ6n3hdsaBy3BiIOpuvpPBq3ST02r7lfsGfJypb8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
