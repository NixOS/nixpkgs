{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,

  npmHooks,
  nodejs,

  cargo-tauri,
  pkg-config,

  libsoup,
  webkitgtk,
}:

rustPlatform.buildRustPackage rec {
  pname = "desktop-postflop";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "b-inary";
    repo = "desktop-postflop";
    rev = "refs/tags/v${version}";
    hash = "sha256-pOPxNHM4mseIuyyWNoU0l+dGvfURH0+9+rmzRIF0I5s=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-HWZLicyKL2FHDjZQj9/CRwVi+uc/jHmVNxtlDuclf7s=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "postflop-solver-0.1.0" = "sha256-coEl09eMbQqSos1sqWLnfXfhujSTsnVnOlOQ+JbdFWY=";
    };
  };

  postPatch = ''
    cp ${./Cargo.lock} src-tauri/Cargo.lock
  '';

  cargoRoot = "src-tauri";
  buildAndTestSubdir = cargoRoot;

  # postflop-solver requires unstable rust features
  env.RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs

    cargo-tauri.hook
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libsoup
    webkitgtk
  ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    changelog = "https://github.com/b-inary/desktop-postflop/releases/tag/v${version}";
    description = "Free, open-source GTO solver for Texas hold'em poker";
    homepage = "https://github.com/b-inary/desktop-postflop";
    license = lib.licenses.agpl3Plus;
    mainProgram = "desktop-postflop";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
