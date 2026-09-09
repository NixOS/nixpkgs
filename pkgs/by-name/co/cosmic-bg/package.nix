{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cosmic-wallpapers,
  libcosmicAppHook,
  just,
  nasm,
  dav1d,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-bg";
  version = "1.6.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-bg";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-tvYVe3H99oB6NYzLjwzX+ccSFh54LAfvuLmFoCIaJp4=";
  };

  postPatch = ''
    substituteInPlace config/src/lib.rs data/v1/all \
      --replace-fail '/usr/share/backgrounds/cosmic/orion_nebula_nasa_heic0601a.jpg' \
      "${cosmic-wallpapers}/share/backgrounds/cosmic/orion_nebula_nasa_heic0601a.jpg"
  '';

  cargoHash = "sha256-j07BZ9JsY6UG9eXVxdn0CTWU8j/cGNA9lXrDsdF40lM=";

  separateDebugInfo = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    just
    libcosmicAppHook
    nasm
  ];

  buildInputs = [
    dav1d
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
    homepage = "https://github.com/pop-os/cosmic-bg";
    description = "Applies Background for the COSMIC Desktop Environment";
    license = lib.licenses.mpl20;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-bg";
  };
})
