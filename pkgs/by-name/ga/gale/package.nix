{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,

  jq,
  moreutils,
  pnpm_10,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nodejs,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,

  glib-networking,
  libsoup_3,
  openssl,
  webkitgtk_4_1,
}:
<<<<<<< HEAD
=======

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gale";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "Kesomannen";
    repo = "gale";
    tag = finalAttrs.version;
    hash = "sha256-SnPYuMYdoY69CWMztuDxw0ohRDU2uECNhBs46hLg+eA=";
  };

<<<<<<< HEAD
  patches = [ ./fix-frontend-backend-tauri-version-mismatch.patch ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    pnpm = pnpm_10;
    fetcherVersion = 1;
    hash = "sha256-ILhAhpY9a50a0KKWs5Y+G3jDyWuySHw8QcOJlYePzmc=";
  };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  postPatch = ''
    jq '.bundle.createUpdaterArtifacts = false' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

<<<<<<< HEAD
=======
  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-DYhPe59qfsSjyMIN31RL0mrHfmE6/I1SF+XutettkO8=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-tWQRYD6hMU7cvtelGryLdpfoEnUKYt7yYNwHTFZ4pLw=";

  nativeBuildInputs = [
    jq
    moreutils
<<<<<<< HEAD
    pnpmConfigHook
    pnpm_10
=======
    pnpm_10.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    nodejs
    cargo-tauri.hook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib-networking # needed to load icons
    libsoup_3
    openssl
    webkitgtk_4_1
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight Thunderstore client";
    homepage = "https://github.com/Kesomannen/gale";
    license = lib.licenses.gpl3Only;
    mainProgram = "gale";
    maintainers = with lib.maintainers; [
      tomasajt
      notohh
    ];
    platforms = lib.platforms.linux;
  };
})
