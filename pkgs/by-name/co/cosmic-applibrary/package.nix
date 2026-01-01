{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  libcosmicAppHook,
  just,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-applibrary";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "1.0.0-beta.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applibrary";
    tag = "epoch-${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-A3OWgTgNeuNqMN4WBVJcAXogL9jHABDRIsN0QjgcPDY=";
  };

  cargoHash = "sha256-M3zyBsNFUQ5dwzJRlaC8m6o5U4teIgwl6jTDYSqW8qw=";
=======
    hash = "sha256-G8zH66v5YLqF8p1WhCBnXeI2ac3igGCAFJTvgeTTCUE=";
  };

  cargoHash = "sha256-s+Q8hj8/dqwGpCq87BWTtk/PmAg55cMI/KLL96SaqUo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

  passthru = {
    tests = {
      inherit (nixosTests)
        cosmic
        cosmic-autologin
        cosmic-noxwayland
        cosmic-autologin-noxwayland
        ;
    };
<<<<<<< HEAD

    updateScript = nix-update-script {
      extraArgs = [
=======
    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "unstable"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-applibrary";
    description = "Application Template for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-app-library";
  };
})
