{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  just,
  libcosmicAppHook,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-monitor";
  version = "1.2.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-monitor";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-6Iz2CMcw131GrgSsSk2FgnwAnges1yMeEwblrusCc24=";
  };

  cargoHash = "sha256-INILXUO4637bcq51OV+ENJG306kXOrKN8547/RRSG0k=";

  separateDebugInfo = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    just
    libcosmicAppHook
    rustPlatform.bindgenHook
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
    homepage = "https://github.com/pop-os/cosmic-monitor";
    description = "COSMIC System Monitor";
    mainProgram = "cosmic-monitor";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
  };
})
