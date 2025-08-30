{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  libcosmicAppHook,
  just,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-weather";
  version = "0-unstable-2025-06-18";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ext-applet-weather";
    rev = "bcab9f3bf027f44b12ec6fb67e6ccc2dc0ae593f";
    hash = "sha256-MrkVVrxJ2ceHKdOWCLz6ps3Jpx2Ggkqc0cajgIFr+vI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-GWjTfOrQj8XJAORjpGpYIMIJpfjL90VZ72OhIurfuto=";

  cargoPatches = [
    (fetchpatch {
      name = "deduplicate-sctk.patch";
      url = "https://patch-diff.githubusercontent.com/raw/cosmic-utils/cosmic-ext-applet-weather/pull/4.diff?full_index=1";
      hash = "sha256-lrW4a3KbCe6MyhjkU1u92hDQ6i+cVZjS53Xfi7oAf1s=";
    })
  ];

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
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
