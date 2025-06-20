{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,

  cargo-tauri_1,
  nodejs,
  npmHooks,
  pkg-config,

  libsoup_2_4,
  webkitgtk_4_0,
}:

rustPlatform.buildRustPackage rec {
  pname = "desktop-postflop";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "b-inary";
    repo = "desktop-postflop";
    tag = "v${version}";
    hash = "sha256-pOPxNHM4mseIuyyWNoU0l+dGvfURH0+9+rmzRIF0I5s=";
  };

  npmDeps = fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    inherit src;
    hash = "sha256-HWZLicyKL2FHDjZQj9/CRwVi+uc/jHmVNxtlDuclf7s=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  useFetchCargoVendor = true;
  cargoHash = "sha256-pMvh2Rr+rMe0nMB9yRDrGatrS36+VM7os0eeBR31oCM=";

  # postflop-solver requires unstable rust features
  env.RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    cargo-tauri_1.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libsoup_2_4
    webkitgtk_4_0
  ];

  meta = {
    changelog = "https://github.com/b-inary/desktop-postflop/releases/tag/${src.tag}";
    description = "Free, open-source GTO solver for Texas hold'em poker";
    homepage = "https://github.com/b-inary/desktop-postflop";
    license = lib.licenses.agpl3Plus;
    mainProgram = "desktop-postflop";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
