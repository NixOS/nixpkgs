{
  lib,
  stdenv,
  rustPlatform,
  cargo-tauri,
  glib-networking,
  nodejs,
  libgudev,
  systemdLibs,
  pnpm,
  openssl,
  nix-update-script,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook4,
  autoPatchelfHook,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sftool-gui";
  version = "1.0.3";
  src = fetchFromGitHub {
    owner = "OpenSiFli";
    repo = "sftool-gui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kjxUl9YrvTgJby+FvUbx5ugucK8NiBqzGBhTi9Zwd1s=";
  };

  cargoHash = "sha256-XAU3ru+TxUo99OQwcXNLJ8gzBOZUkC8UCAApz7M/QTM=";
  cargoRoot = "src-tauri";

  pnpmDeps = pnpm.fetchDeps {
    fetcherVersion = 2;
    inherit (finalAttrs) pname version src;
    hash = "sha256-gamgu9koBf+JLDswi3eGXRZybF8UiYE8CoifpQCgLaI=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    pnpm.configHook
    nodejs
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook4
    autoPatchelfHook
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking # Most Tauri apps need networking
    webkitgtk_4_1
    libgudev
    systemdLibs
  ];

  # Set our Tauri source directory
  # And make sure we build there too
  buildAndTestSubdir = finalAttrs.cargoRoot;

  passthru = {
    inherit (finalAttrs) pnpmDeps;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Download tool for the SiFli family of chips";
    homepage = "https://github.com/OpenSiFli/sftool-gui";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "sftool";
  };
})
