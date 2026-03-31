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
  fetchpatch2,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-greeter";
  version = "1.0.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-greeter";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-HP2Dl/vEX4K3XaXtjOpN1EW6uE4RuLm2+RMLB3QvOXQ=";
  };

  cargoHash = "sha256-KLIUE3+iAZbNB6YPSl75I6jHwa1RBN+go5A7RFi5LxE=";

  cargoPatches = [
    (fetchpatch2 {
      # https://github.com/pop-os/cosmic-greeter/pull/426
      name = "security-hardening.patch";
      url = "https://github.com/pop-os/cosmic-greeter/commit/6049b50f8984f98c2c61117d86b9f6f9befc9300.patch?full_index=1";
      hash = "sha256-T9tc4Krmp5jieKhbaTgI1CByWqSWy97HWcKMIXzr7MU=";
    })
  ];

  env = {
    VERGEN_GIT_COMMIT_DATE = "2025-12-05";
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

    updateScript = nix-update-script {
      extraArgs = [
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
