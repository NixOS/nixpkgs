{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-weather";
  version = "0-unstable-2026-03-11";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ext-applet-weather";
    rev = "d63918979b5208a49a6da2e7e338d706248fdae4";
    hash = "sha256-OswoiPq27efi8lIrW3BnsVGkfFLMpasmHEXWSLIxNu4=";
  };

  cargoHash = "sha256-4n8NC7IAhANT9FnzBJzzpsKyw8clJw2uqN1Ie2PK+eE=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Simple weather info applet for COSMIC";
    homepage = "https://github.com/cosmic-utils/cosmic-ext-applet-weather";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-applet-weather";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
  };
}
