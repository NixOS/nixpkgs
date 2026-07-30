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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "minimon-applet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7DAP4Cmg0xIPTiAKwCIxHBEhTdPPX1KywZqTaoRIRhk=";
  };

  cargoHash = "sha256-vj5PzOXpTRXGXgxIz0Q2BmGbsWInuxA4aYlhM77ZTMM=";

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
