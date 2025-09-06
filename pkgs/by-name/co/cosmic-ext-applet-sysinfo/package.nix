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
  pname = "cosmic-ext-applet-sysinfo";
  version = "0-unstable-2025-06-18";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ext-applet-sysinfo";
    rev = "3e53828b33084bab26a8ff9c177754e435aef711";
    hash = "sha256-3Ih/5uS1vDhwjr5YGXd3AaROFngEqcRzuJxdUKi1qz8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-oUw7oBOT1I/eBQuKuTQ4UWuksYWSyS6kd4fRGHC4ELY=";

  cargoPatches = [
    (fetchpatch {
      name = "deduplicate-sctk.patch";
      url = "https://patch-diff.githubusercontent.com/raw/cosmic-utils/cosmic-ext-applet-sysinfo/pull/4.diff?full_index=1";
      hash = "sha256-RIa6pl8N/ipf+kJcZBQvqwBtk2BlyievCMAuOVeE7KA=";
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
    description = "Simple system info applet for COSMIC";
    homepage = "https://github.com/cosmic-utils/cosmic-ext-applet-sysinfo";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-applet-sysinfo";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
