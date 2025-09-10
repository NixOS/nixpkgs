{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,

  jq,
  moreutils,
  pnpm_10,
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
  version = "1.9.6";

  src = fetchFromGitHub {
    owner = "Kesomannen";
    repo = "gale";
    tag = finalAttrs.version;
    hash = "sha256-zgwxr04MGs8EqrZBY5y8F1GNiaJbJUvpND52oLXtCrk=";
  };

  postPatch = ''
    jq '.bundle.createUpdaterArtifacts = false' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-QQXP/x7AjDtUpe6h+pC6vUsIAptv1kN/1MJZjHAIdMo=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-+ZZwYpYvIYmZFg9PA7kD/mBU1TrpEQIsoMmHSWyX+Xc=";

  nativeBuildInputs = [
    jq
    moreutils
    pnpm_10.configHook
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
