{
  lib,
  stdenv,
  rustPlatform,
  pkg-config,
  cargo-tauri,
  bun,
  nodejs,
  cargo,
  rustc,
  jq,
  wrapGAppsHook4,
  makeWrapper,
  dbus,
  glib,
  gtk3,
  libsoup_3,
  librsvg,
  libappindicator-gtk3,
  glib-networking,
  openssl,
  webkitgtk_4_1,
  opencode,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "opencode-desktop";
  inherit (opencode)
    version
    src
    node_modules
    patches
    ;

  cargoRoot = "packages/desktop/src-tauri";
  cargoHash = "sha256-Sfw/1380knqusED8OJcCn0D7erkX1sLtQq9m6Dd0v4Y=";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  nativeBuildInputs = [
    pkg-config
    cargo-tauri.hook
    bun
    nodejs # for patchShebangs node_modules
    cargo
    rustc
    jq
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenv.isLinux [
    dbus
    glib
    gtk3
    libsoup_3
    librsvg
    libappindicator-gtk3
    glib-networking
    openssl
    webkitgtk_4_1
  ];

  strictDeps = true;

  tauriBuildFlags = [
    "--config"
    "tauri.conf.json"
    "--config"
    "tauri.prod.conf.json"
    "--no-sign"
  ];

  preBuild = ''
    cp -a ${finalAttrs.node_modules}/{node_modules,packages} .
    chmod -R u+w node_modules packages
    patchShebangs node_modules
    patchShebangs packages/desktop/node_modules

    mkdir -p packages/desktop/src-tauri/sidecars
    cp ${opencode}/bin/opencode packages/desktop/src-tauri/sidecars/opencode-cli-${stdenv.hostPlatform.rust.rustcTarget}
  '';

  meta = {
    description = "AI coding agent desktop client";
    homepage = "https://opencode.ai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
    ];
    mainProgram = "OpenCode";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
