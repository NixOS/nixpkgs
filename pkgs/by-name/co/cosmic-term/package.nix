{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  just,
  libcosmicAppHook,
  fontconfig,
  freetype,
  libinput,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-term";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "1.0.0-beta.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-term";
    tag = "epoch-${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-FPg/dXk2uZFPWZ7JgZo5zRSoBlXCfxGI7uRmq9o5LL8=";
  };

  cargoHash = "sha256-ImWHjEKgu9FQR52A3GjnAkxlPduKuzSUAOANYr0DzMA=";
=======
    hash = "sha256-kyswCFnor2tg64BodSwiRYqzjxRN6r7zqm2z/egmX1I=";
  };

  cargoHash = "sha256-7+1tvJ/B+YITI5XXr1A+jlRRNRoNZ1ZsGeeAfGPT/00=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    just
    pkg-config
    libcosmicAppHook
  ];

  buildInputs = [
    fontconfig
    freetype
    libinput
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
    homepage = "https://github.com/pop-os/cosmic-term";
    description = "Terminal for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-term";
  };
})
