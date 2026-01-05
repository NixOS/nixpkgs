{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  just,
  libcosmicAppHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-ext-applet-minimon";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "minimon-applet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tUAp6GN5oJYhALjTpEELMOEBpfao5D9B0hl2ecNtwMg=";
  };

  cargoHash = "sha256-qgqlEufv9vLLIOcDLiX76xRcXal1Q0S5726ua+8R8Ek=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-applet-minimon"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/cosmic-utils/minimon-applet/releases/tag/v${finalAttrs.version}";
    description = "COSMIC applet for displaying CPU/Memory/Network/Disk/GPU usage in the Panel or Dock";
    homepage = "https://github.com/cosmic-utils/minimon-applet";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-applet-minimon";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
  };
})
