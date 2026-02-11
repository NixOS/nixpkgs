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
  pname = "cosmic-ext-applet-sysinfo";
  version = "0-unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ext-applet-sysinfo";
    rev = "f92912ee466fbb1b9b7e59f0cc49fb14dfddbc58";
    hash = "sha256-3p1xPOciNFlROR02hnaVwCaHPQI3mhXamy0WBD9ndWk=";
  };

  cargoHash = "sha256-sLoT/p7Au5s16J08RlxK+o4ayUzKO30GfcUwr8kGFl8=";

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
    description = "Simple system info applet for COSMIC";
    homepage = "https://github.com/cosmic-utils/cosmic-ext-applet-sysinfo";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-applet-sysinfo";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
  };
}
