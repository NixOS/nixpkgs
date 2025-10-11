{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-caffeine";
  version = "0-unstable-2025-10-04";

  src = fetchFromGitHub {
    owner = "tropicbliss";
    repo = "cosmic-ext-applet-caffeine";
    rev = "0e4af3b53ec37d065323fcdbf9ee1049aae3db88";
    hash = "sha256-vLxLOGs4VsDWrbomZz2s+xWWgPkmKVrPJAMVHRs4Vqo=";
  };

  cargoHash = "sha256-nl/giMIQ5xNSOgjv67OMWkfuAVtdIcqZDbXC1mYwXBM=";

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
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-caffeine"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Caffeine Applet for the COSMIC desktop";
    homepage = "https://github.com/tropicbliss/cosmic-ext-applet-caffeine";
    license = lib.licenses.mit;
    mainProgram = "cosmic-ext-applet-caffeine";
    maintainers = [ lib.maintainers.HeitorAugustoLN ];
    platforms = lib.platforms.linux;
  };
}
