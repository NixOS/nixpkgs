{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  pkg-config,
  glib,
  libinput,
  fontconfig,
  freetype,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-edit";
  version = "1.1.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-edit";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-5DsnhaiJgmTakn+q9o2Q7IeuakAC/j0Ck3F3pfFx/EA=";
  };

  postPatch = ''
    substituteInPlace justfile --replace-fail '#!/usr/bin/env' "#!$(command -v env)"
  '';

  cargoHash = "sha256-2E+98uWtahyQufoZTzdUtkwbuISsUHwlqOmMSpyi1O8=";

  separateDebugInfo = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    just
    pkg-config
    libcosmicAppHook
  ];

  buildInputs = [
    glib
    libinput
    fontconfig
    freetype
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
    homepage = "https://github.com/pop-os/cosmic-edit";
    description = "Text Editor for the COSMIC Desktop Environment";
    mainProgram = "cosmic-edit";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
  };
})
