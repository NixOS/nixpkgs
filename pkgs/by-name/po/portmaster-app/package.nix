{
  portmaster,

  buildNpmPackage,

  lib,
  rustPlatform,
  cargo-tauri,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  importNpmLock,
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "portmaster-app";

  inherit (portmaster) version src;

  useFetchCargoVendor = true;
  cargoHash = "sha256-Noi1ft7P36AQSyutxHZY0966ZwAuXoqu2oLviN/qM0w=";

  cargoRoot = "desktop/tauri/src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  npmDeps = fetchNpmDeps {
    pname = "${finalAttrs.pname}-npm-deps";
    inherit (finalAttrs) version;
    src = "${finalAttrs.src}/desktop/angular";
    hash = "sha256-Mqg6+3YYxJk0VJneprCEfSJ6MKGzR6j+BupojODJDEg=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
  ];

  meta = {
    inherit (portmaster.meta) homepage license changelog;
    description = portmaster.meta.description + " (desktop app)";
    maintainers = with lib.maintainers; [
      nyanbinary
      griffi-gh
    ];
  };
})
