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
  version = "1.0.0-beta.9";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-term";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-RSW5oy5lYY15PbZaoxEwLy6g1+I0pOFBNR3pN5HuEqE=";
  };

  cargoHash = "sha256-gLPNX9CEortxDPM9+QYiHlCTPINnoYL1P90HWVPcezY=";

  postPatch = ''
    substituteInPlace $cargoDepsCopy/cosmic-files-*/src/operation/mod.rs \
      --replace-fail 'return OperationError::from_msg("Restoring from trash is not supported on macos");' \
                     'return Err(OperationError::from_msg("Restoring from trash is not supported on macos"));'
  '';

  nativeBuildInputs = [
    just
    pkg-config
    libcosmicAppHook
  ];

  buildInputs = [
    fontconfig
    freetype
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libinput
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  # Default features include wayland, dbus and secret-service,
  # which we don't want on darwin.
  buildNoDefaultFeatures = stdenv.hostPlatform.isDarwin;
  buildFeatures = lib.optionals stdenv.hostPlatform.isDarwin [
    "wgpu"
  ];

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
    homepage = "https://github.com/pop-os/cosmic-term";
    description = "Terminal for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.unix;
    mainProgram = "cosmic-term";
  };
})
