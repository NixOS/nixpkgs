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
  version = "1.0.0-alpha.6";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-randr";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-Sqxe+vKonsK9MmJGtbrZHE7frfrjkHXysm0WQt7WSU4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-UQ/fhjUiniVeHRQYulYko4OxcWB6UhFuxH1dVAfAzIY=";

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
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-randr"
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
    maintainers = lib.teams.cosmic.members;
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-randr";
  };
})
