{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  cargo-tauri,
  wrapGAppsHook4,
  pkg-config,
  openssl,
  glib-networking,
  webkitgtk_4_1,
  cairo,
  gdk-pixbuf,
  gtk3,
  libsoup_3,
  pango,
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
  cargoHash = "sha256-kui9FVuknNHtP30f08vvSjWJOaNIWvil/ruQqxtKqys=";

  cargoBuildFlags = [
    "--package"
    "SJMCL"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags ++ [
    "--all-targets"
  ];

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-bOlKbuhyFifjnSB7eeVXAT0aVC8Vxp7DiR7D8vJE8LU=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    cargo-tauri.hook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook4
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
    glib-networking
    webkitgtk_4_1
    cairo
    gdk-pixbuf
    gtk3
    libsoup_3
    pango
  ];

  meta = {
    description = "A Minecraft launcher from @SJMC-Dev";
    homepage = "https://github.com/UNIkeEN/SJMCL";
    changelog = "https://github.com/UNIkeEN/SJMCL/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ FrdrCkII ];
    mainProgram = "SJMCL";
    platforms = lib.platforms.all;
  };
})
