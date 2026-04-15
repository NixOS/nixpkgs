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
  version = "0-unstable-2026-03-26";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ext-applet-sysinfo";
    rev = "a01f7d1217de6dcc961f258bef5ff2eb54fa84f3";
    hash = "sha256-BtCArWWC5WbObpNp2OBxfn9Au+3SS+Gj/JBptDs8qbk=";
  };

  cargoHash = "sha256-vD90KMBI1bQTwazVnEMFo3eKXmLLI9QswdIwz+XoDho=";

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
