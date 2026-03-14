{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  cargo-tauri,
  wrapGAppsHook4,
  pkg-config,
  openssl,
  cairo,
  gdk-pixbuf,
  glib-networking,
  gtk3,
  libsoup_3,
  pango,
  webkitgtk_4_1,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sjmcl-unwrapped";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "UNIkeEN";
    repo = "SJMCL";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w+/qr+jndkyfjKyCaVPQnarUROahD7xEWY06nlc4jZM=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoLock.lockFile = "${finalAttrs.src}/${finalAttrs.cargoRoot}/Cargo.lock";
  tauriBundleType = "deb";
  doCheck = false;

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-bOlKbuhyFifjnSB7eeVXAT0aVC8Vxp7DiR7D8vJE8LU=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    cargo-tauri.hook
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    openssl
    cairo
    gdk-pixbuf
    glib-networking
    gtk3
    libsoup_3
    pango
    webkitgtk_4_1
  ];

  meta = {
    description = "A Minecraft launcher from @SJMC-Dev";
    homepage = "https://github.com/UNIkeEN/SJMCL";
    changelog = "https://github.com/UNIkeEN/SJMCL/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ FrdrCkII ];
    mainProgram = "SJMCL";
    platforms = lib.platforms.all;
  };
})
