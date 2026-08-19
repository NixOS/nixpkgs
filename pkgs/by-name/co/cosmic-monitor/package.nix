{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  just,
  libcosmicAppHook,
  autoAddDriverRunpath,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-monitor";
  version = "1.5.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-monitor";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-blv+znOdRkQE/yHRMwNcCw2fIztXHQYmWbQEoIME3jo=";
  };

  cargoHash = "sha256-Pu+xC8tLOFy6SBWaMe/Q/q87HhVzO4Rgzs0aufKAJUg=";

  separateDebugInfo = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    just
    libcosmicAppHook
    rustPlatform.bindgenHook
    autoAddDriverRunpath # for GPU monitoring
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
