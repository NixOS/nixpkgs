{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  pkg-config,
  alsa-lib,
  ffmpeg,
  glib,
  gst_all_1,
  libglvnd,
  libgbm,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-player";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "1.0.0-beta.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-player";
    tag = "epoch-${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-+DFMBMJuKPZ8T9PdR3/Qt9lF688TYS1AhbkVK2yudU4=";
  };

  cargoHash = "sha256-Z0+6jtvJ3z/ptcqrbvSuXgjH2liASNJwBIKiHbrVBT8=";
=======
    hash = "sha256-RNDc+NCih1bsdqa4DCOrtiKPsdVaQ6fvj9VGQAoNri8=";
  };

  cargoHash = "sha256-ST/04USAIHvySOoKvh5EPCDlUOjHxbiRFouLunaleKw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    just
    pkg-config
    libcosmicAppHook
    rustPlatform.bindgenHook
  ];

  # Largely based on lilyinstarlight's work linked below
  # https://github.com/lilyinstarlight/nixos-cosmic/blob/main/pkgs/cosmic-player/package.nix

  buildInputs = [
    alsa-lib
    ffmpeg
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    libgbm
    libglvnd
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

  postInstall = ''
    libcosmicAppWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
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
    homepage = "https://github.com/pop-os/cosmic-player";
    description = "Media player for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-player";
  };
})
