{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  pkg-config,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-screenshot";
  version = "1.0.6";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-screenshot";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-IyjrXj9UElfWKU7t9JpJi4WvOpgteg/Y3tvj3ZukQYI=";
  };

  cargoHash = "sha256-O8fFeg1TkKCg+QbTnNjsH52xln4+ophh/BW/b4zQs9o=";

  nativeBuildInputs = [
    just
    pkg-config
  ];

  dontUseJustBuild = true;

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
    homepage = "https://github.com/pop-os/cosmic-screenshot";
    description = "Screenshot tool for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-screenshot";
  };
})
