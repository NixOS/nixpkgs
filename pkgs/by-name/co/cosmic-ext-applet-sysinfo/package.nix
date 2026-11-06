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
  version = "0-unstable-2026-10-30";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ext-applet-sysinfo";
    rev = "0a8c9810640ade6d3714c715fa71230daf0d365a";
    hash = "sha256-AlPwDa5PLs/0UbT7BLbcN1KVGRixLwYAIGklsfdDpNk=";
  };

  cargoHash = "sha256-zgVHjySWPHqtL7noCOpR871Qp9yVw8og3GBHo/V1m5k=";

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
