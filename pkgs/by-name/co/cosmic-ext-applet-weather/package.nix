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
  version = "0-unstable-2026-02-03";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ext-applet-weather";
    rev = "ea8a506a6ca56b6ac6c4952012880bf1d6227631";
    hash = "sha256-DnYOOeCcf/fuNuPJ8MeolfAyGJdNWONawaF1HV8mr4k=";
  };

  cargoHash = "sha256-tj0skQNt0p6UMUnU6HXw6ZAjEkCuuF4vg1aoWytqCos=";

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
