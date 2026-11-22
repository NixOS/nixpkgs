{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  just,
  libcosmicAppHook,
  pipewire,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-ext-applet-privacy-indicator";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "D-Brox";
    repo = "cosmic-ext-applet-privacy-indicator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W7ZS/wS3il0kM6dys/PsxwxVRiyMea9jEup0ogIb9DQ=";
  };

  cargoHash = "sha256-llRReOfYZG4nFNci7XoyR4YXj37CHsXEX4ejy6orbUs=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [ pipewire ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-privacy-indicator"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/D-Brox/cosmic-ext-applet-privacy-indicator/releases/tag/v${finalAttrs.version}";
    description = "Privacy indicator applet for the COSMIC Desktop Environment";
    homepage = "https://github.com/D-Brox/cosmic-ext-applet-privacy-indicator";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-applet-privacy-indicator";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
  };
})
