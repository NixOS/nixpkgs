{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  libcosmicAppHook,
  just,
  nix-update-script,
  nixosTests,
}:

let
  version = "1.7.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-app-library";
    tag = "epoch-${version}";
    hash = "sha256-g77/wMG0e8yMYLnwfOTupJlBOKKGYpsbRNxkjCsCfvY=";
  };

  xdgen-generate = rustPlatform.buildRustPackage {
    pname = "xdgen-generate";
    version = "0.1.0";

    src = "${src}/scripts/xdgen";

    cargoHash = "sha256-u3ia4MOL1cNj3K5ofJ5piwEDsDna2ImZh9uSVRPIQ/o=";

    meta.mainProgram = "xdgen-generate";
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-app-library";
  inherit version;

  inherit src;

  cargoHash = "sha256-pr90LG3H8hKD1dJAeO4vfLQLlihB7gjwvhlDNHdRTec=";

  separateDebugInfo = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    just
    libcosmicAppHook
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

  preInstall = ''
    env \
        APP_ID=com.system76.CosmicAppLibrary \
        APP_NAME=cosmic-app-library \
        ${lib.getExe xdgen-generate}
  '';

  passthru = {
    # so that we can build the script derivation by referencing this derivation
    inherit xdgen-generate;
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
    homepage = "https://github.com/pop-os/cosmic-app-library";
    description = "Application Template for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-app-library";
  };
})
