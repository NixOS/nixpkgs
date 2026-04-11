{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  just,
  libcosmicAppHook,
  glib,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-files";
  version = "1.0.8";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-files";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-KXXNYNGun1stXXzY4OWzOVLrLXAs5g7NNaSYajavDvU=";
  };

  cargoHash = "sha256-HMHS6HrOUVnrWbyGi9wadl9++onBNNCRw4r4nohvQzI=";

  patches = [
    (fetchpatch {
      # patch for fixing build error introduced in `epoch-1.0.7`
      url = "https://github.com/pop-os/cosmic-files/commit/49e3d95e7a5e02c279f2be1f1f4dfdba2fb532dc.patch";
      hash = "sha256-Ohf3K+ehFvIurPOReFDML+wfBvdxCi7Ef3eCoSLnXFM=";
    })
  ];

  nativeBuildInputs = [
    just
    libcosmicAppHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [ glib ];

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

    cargoTestFlags="$defaultCargoTestFlags --package cosmic-files"
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
