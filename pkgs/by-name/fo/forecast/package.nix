{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  libcosmicAppHook,
  just,

  # buildInputs
  openssl,

  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "forecast";
  version = "0-unstable-2025-10-21";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "forecast";
    rev = "8f04cafd809d58bdd46556b66f3aa4574e81fcbd";
    hash = "sha256-DRShCI/tBh/a3IM/UH8yujlJyEeqGJ+kbnqSF8AibS0=";
  };

  cargoHash = "sha256-di7zjwI0/6NB2cAih3d7iqwSb+o/607jbgJN1MtbZX8=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  buildInputs = [ openssl ];

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-forecast"
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "branch=HEAD"
      ];
    };
  };

  meta = {
    description = "Weather app written in rust and libcosmic";
    homepage = "https://github.com/cosmic-utils/forecast";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      HeitorAugustoLN
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-forecast";
  };
}
