{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  pkg-config,
  wayland,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-randr";
  version = "1.0.0-beta.2";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-randr";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-daP2YZ7B1LXzqh2n0KoSTJbitdK+hlZO+Ydt9behzmQ=";
  };

  cargoHash = "sha256-tkmBthh+nM3Mb9WoSjxMbx3t0NTf6lv91TwEwEANS6U=";

  nativeBuildInputs = [
    just
    pkg-config
  ];

  buildInputs = [ wayland ];

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
        "--version"
        "unstable"
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-randr";
    description = "Library and utility for displaying and configuring Wayland outputs";
    license = lib.licenses.mpl20;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-randr";
  };
})
