{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,

  jq,
  moreutils,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,

  glib-networking,
  libsoup_3,
  openssl,
  webkitgtk_4_1,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gale";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "Kesomannen";
    repo = "gale";
    tag = finalAttrs.version;
    hash = "sha256-b+dngnrII8hBQXsdHKdZKAwRXMdztpNUWG7G/lrvJpM=";
  };

  patches = [ ./fix-frontend-backend-tauri-version-mismatch.patch ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-IDt4sVApwI4FKKIhFOZQq4tGysDYFYuYkuY3l0mDU6A=";
  };

  postPatch = ''
    jq '.bundle.createUpdaterArtifacts = false' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-fEOrWHkuJH/Y9gbp3wAn/dVgDwtCg3IRHcJSxok9Ub8=";

  nativeBuildInputs = [
    jq
    moreutils
    pnpmConfigHook
    pnpm_10
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
