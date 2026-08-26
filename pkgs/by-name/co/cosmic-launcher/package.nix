{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  libcosmicAppHook,
  nix-update-script,
  nixosTests,
}:

let
  version = "1.7.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-launcher";
    tag = "epoch-${version}";
    hash = "sha256-zlqFX2DNQu5LqxbBcPK22H8N076k2JwmhNaVcnZbk1I=";
  };

  xdgen-generate = rustPlatform.buildRustPackage {
    pname = "xdgen-generate";
    version = "0.1.0";

    src = "${src}/scripts/xdgen";

    cargoHash = "sha256-Zf41g3ZpY0McDGhvmKReV77p4/laHUIBNievOMGbToE=";

    meta.mainProgram = "xdgen-generate";
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-launcher";
  inherit version;

  inherit src;

  cargoHash = "sha256-rD3zgkf13cc2YgDWcKxs3MDH4aORVz+dsxpm5tqrszU=";

  separateDebugInfo = true;
  __structuredAttrs = true;

  env."CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" = "--cfg tokio_unstable";

  nativeBuildInputs = [
    just
    libcosmicAppHook
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  preInstall = ''
    env \
        APP_ID=com.system76.CosmicLauncher \
        APP_NAME=cosmic-launcher \
        ${lib.getExe xdgen-generate}
  '';

  passthru = {
    # so that we can build the script derivation by referencing this derivation
    inherit xdgen-generate;
    tests = {
      inherit (nixosTests)
        cosmic
        cosmic-autologin
        cosmic-noxwayland
        cosmic-autologin-noxwayland
        ;
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-launcher";
    description = "Launcher for the COSMIC Desktop Environment";
    mainProgram = "cosmic-launcher";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
  };
})
