{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,

  pnpm_10,
  nodejs,

  rustPlatform,
  cargo-tauri,
  wrapGAppsHook4,
  pkg-config,
  glib-networking,
  webkitgtk_4_1,
  openssl,
}:

let
  pnpm = pnpm_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fedistar";
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "h3poteto";
    repo = "fedistar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q2j6K4ys/z77+n3kdGJ15rWbFlbbIHBWB9hOARsgg2A=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  cargoHash = "sha256-ZJgyrFDtzAH3XqDdnJ27Yn+WsTMrZR2+lnkZ6bw6hzg=";

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-xXVsjAXmrsOp+mXrYAxSKz4vX5JApLZ+Rh6hrYlnJDI=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook

    pnpm.configHook
    pnpm
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

  # A fix for a problem with Tauri (tauri-apps/tauri#9304)
  preFixup = ''
    gappsWrapperArgs+=(
      --set-default WEBKIT_DISABLE_DMABUF_RENDERER 1
    )
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "fedistar-frontend"
    ];
  };

  meta = {
    description = "Multi-column Fediverse client application for desktop";
    homepage = "https://fedistar.net/";
    mainProgram = "fedistar";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ noodlez1232 ];
    changelog = "https://github.com/h3poteto/fedistar/releases/tag/v${finalAttrs.version}";
  };
})
