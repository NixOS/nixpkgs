{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  cmake,
  just,
  cosmic-randr,
  libinput,
  linux-pam,
  udev,
  coreutils,
  xkeyboard_config,
  nix-update-script,
  nixosTests,
  orca,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-greeter";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "1.0.0-beta.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-greeter";
    tag = "epoch-${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-HP2Dl/vEX4K3XaXtjOpN1EW6uE4RuLm2+RMLB3QvOXQ=";
=======
    hash = "sha256-r/xhJR3xtLxPusMUKzS2PGsS51m1jfoxZByJWcXLaoY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoHash = "sha256-4yRBgFrH4RBpuvChTED+ynx+PyFumoT2Z+R1gXxF4Xc=";

  env = {
<<<<<<< HEAD
    VERGEN_GIT_COMMIT_DATE = "2025-12-05";
=======
    VERGEN_GIT_COMMIT_DATE = "2025-11-20";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    VERGEN_GIT_SHA = finalAttrs.src.tag;
  };

  cargoBuildFlags = [ "--all" ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    cmake
    just
    libcosmicAppHook
  ];

  buildInputs = [
    cosmic-randr
    libinput
    linux-pam
    udev
    orca
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

  postPatch = ''
    substituteInPlace src/greeter.rs --replace-fail '/usr/bin/env' '${lib.getExe' coreutils "env"}'
    substituteInPlace src/greeter.rs --replace-fail '/usr/bin/orca' '${lib.getExe orca}'
  '';

  preFixup = ''
    libcosmicAppWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ cosmic-randr ]}
      --set-default X11_BASE_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.xml
      --set-default X11_BASE_EXTRA_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/extra.xml
    )
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
    homepage = "https://github.com/pop-os/cosmic-greeter";
    description = "Greeter for the COSMIC Desktop Environment";
    mainProgram = "cosmic-greeter";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
  };
})
