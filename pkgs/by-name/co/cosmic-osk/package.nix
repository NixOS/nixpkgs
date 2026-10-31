{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  udev,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-osk";
  version = "1.11.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osk";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-rw8BMxgr5MzmCj8THSOr/TE2GsAMxgC2YXgONVppYzc=";
  };

  cargoHash = "sha256-3aAaceBp6fDQc0KDwY5L922tGvK+5z5Kbzyy+De6Hkg=";

  separateDebugInfo = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    just
    libcosmicAppHook
  ];

  buildInputs = [
    udev
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

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-osk";
    description = "COSMIC On-Screen Keyboard";
    mainProgram = "cosmic-osk";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    upgradeGroup = lib.upgradeGroups.cosmic;
    platforms = lib.platforms.linux;
  };
})
