{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-panel";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "1.0.0-beta.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-panel";
    tag = "epoch-${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-1Xwe1uONJbl4wq6QBbTI1suLiSlTzU4e/5WBccvghHE=";
=======
    hash = "sha256-gvEHieM8osGyRrkeE8gEOPduTv3y3KgoZ2YhFgW5qp8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoHash = "sha256-ZkjXZrcA4qKHSjEOxj7+j10PxJw/du8B2Mee2fxPJxs=";

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
    homepage = "https://github.com/pop-os/cosmic-panel";
    description = "Panel for the COSMIC Desktop Environment";
    mainProgram = "cosmic-panel";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
  };
})
