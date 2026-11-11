{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,

  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,

  rustPlatform,
  cargo-tauri,
  wrapGAppsHook4,
  pkg-config,
  glib-networking,
  webkitgtk_4_1,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fedistar";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "h3poteto";
    repo = "fedistar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iQnKC6R9kXyQUZXjbihDr8l5XdQ266azP6hBqWBsEZM=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  cargoHash = "sha256-DJN1HvlYfruQawk2+2JAx5tx61haIG0NKezyycjL7DA=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-DcaetxlNiXWYbkxC6TXpOhx4TgIiHdOkquVHxM6jROo=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook

    pnpmConfigHook
    pnpm_10
    nodejs

    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
    glib-networking
    webkitgtk_4_1
  ];

  doCheck = false; # This version's tests do not pass

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Multi-column Fediverse client application for desktop";
    homepage = "https://fedistar.net/";
    mainProgram = "fedistar";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ noodlez1232 ];
    changelog = "https://github.com/h3poteto/fedistar/releases/tag/v${finalAttrs.version}";
  };
})
