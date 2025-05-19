{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  just,
  libcosmicAppHook,
  jq,
  gnused,
  glib,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-files";
  version = "1.0.0-alpha.7";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-files";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-bI5yTpqU2N6hFwI9wi4b9N5onY5iN+8YDM3bSgdYxjQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5W6HF/dvZ7mQjodOoOt+GCw2lMg5qV5cH9zbdEyMBls=";
  cargoPatches = [
    (fetchpatch {
      url = "https://github.com/pop-os/cosmic-files/commit/e740cf4968f227a48d12ca9e12f8ae7888d4a6ed.patch";
      hash = "sha256-juETvT/s7qZewcEdmn0/ysGqJ63FQ3JX5m3MYzo6idQ=";
    })
  ];

  env = {
    VERGEN_GIT_COMMIT_DATE = "2025-04-22";
    VERGEN_GIT_SHA = finalAttrs.src.tag;
  };

  nativeBuildInputs = [
    just
    libcosmicAppHook
    jq
    gnused
  ];

  buildInputs = [ glib ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-files"
    "--set"
    "applet-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-files-applet"
  ];

  # This is needed since by setting cargoBuildFlags, it would build both the applet and the main binary
  # at the same time, which would cause problems with the desktop items applet
  buildPhase = ''
    runHook preBuild

    defaultCargoBuildFlags="$cargoBuildFlags"

    cargoBuildFlags="$defaultCargoBuildFlags --package cosmic-files"
    runHook cargoBuildHook

    cargoBuildFlags="$defaultCargoBuildFlags --package cosmic-files-applet"
    runHook cargoBuildHook

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    defaultCargoTestFlags="$cargoTestFlags"

    cargoTestFlags="$defaultCargoTestFlags --package cosmic-files --no-default-features --features $(cargo metadata --no-deps --format-version 1 | jq --raw-output '.packages[] | select(.name == "cosmic-files") | .features.default | join(",")' | sed -e 's/io-uring,//')"
    runHook cargoCheckHook

    cargoTestFlags="$defaultCargoTestFlags --package cosmic-files-applet"
    runHook cargoCheckHook

    runHook postCheck
  '';

  passthru = {
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
        "--version"
        "unstable"
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-files";
    description = "File Manager for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-files";
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
  };
})
