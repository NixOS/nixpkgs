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
  version = "0-unstable-2026-10-01";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "forecast";
    rev = "86b44fa1643e72e127933a8a7e9599b84d4c73b5";
    hash = "sha256-acr3o76CQoJAMXvFGl6y6gcoiJlbOS9f5xS3SxnhueQ=";
  };

  cargoHash = "sha256-S27A8pn+mrbUmuo5Wd1C9R9r6UxGFAAL9od6tpsBWPY=";

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
