{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  libcosmicAppHook,
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

  cargoHash = "sha256-7AOdSk9XIXFCDyCus3XgOK3ZBVa4CvX+NFM0jHf7Wbs=";

  env = {
    VERGEN_GIT_COMMIT_DATE = "2025-04-22";
    VERGEN_GIT_SHA = finalAttrs.src.tag;
  };

  nativeBuildInputs = [
    just
    libcosmicAppHook
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

    # Some tests with the `compio` runtime expect io_uring support but that
    # is disabled in the Nix sandbox and the tests fail because they can't
    # run in the sandbox. Ideally, the `compio` crate should fallback to a
    # non-io_uring runtime but for some reason, that doesn't happen.
    cargoTestFlags="$defaultCargoTestFlags --package cosmic-files -- \
      --skip operation::tests::copy_dir_to_same_location \
      --skip operation::tests::copy_file_to_same_location \
      --skip operation::tests::copy_file_with_diff_name_to_diff_dir \
      --skip operation::tests::copy_file_with_extension_to_same_loc \
      --skip operation::tests::copy_to_diff_dir_doesnt_dupe_files \
      --skip operation::tests::copying_file_multiple_times_to_same_location"
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
