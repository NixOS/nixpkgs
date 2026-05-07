{
  lib,
  stdenv,
  rustPlatform,
  cargo-tauri,
  glib-networking,
  nodejs,
  libgudev,
  systemdLibs,
  fetchPnpmDeps,
  pnpmConfigHook,
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
  version = "1.1.4-unstable-2026-04-16";
  src = fetchFromGitHub {
    owner = "OpenSiFli";
    repo = "sftool-gui";
    rev = "e182a5973a4e23f8af078f3480a8b2416d7439b3";
    hash = "sha256-6wYf0DNn5cjJTeuVfOB91RQP/E2YWr6PlGUnzZdwgNY=";
  };

  patches = [
    # We don't want tauri to bundle the built binaries as we only use them and not the
    # bundled .deb, .appimage, and so on. Bundling the binaries would also require a signing
    # key, which we don't have.
    ./disable-bundling.patch
  ];

  cargoHash = "sha256-hwQJnhWgPqQ3ZudCsEEuWoygYDcUKXgWz15dHZ+vR6Q=";
  cargoRoot = "src-tauri";

  pnpmDeps = fetchPnpmDeps {
    fetcherVersion = 3;
    inherit (finalAttrs) pname version src;
    hash = "sha256-DwDXfbwgt/OSNOQbzCBlathX9QDnbEsXZLsgB67LOEk=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    pnpmConfigHook
    pnpm
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
