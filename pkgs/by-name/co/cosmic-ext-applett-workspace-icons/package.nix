{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-ext-applet-workspace-icons";
  version = "1.2.0";

  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "crocodile";
    repo = "cosmic-ext-applet-workspace-icons";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gJfT7GpTRVlSJVHnEm4ezaWmJpObVz3Sjkd0ELYZQU4=";
  };

  cargoHash = "sha256-fuCmcnGKY/AjovGSBbrnifXY6iiWyXaPM0YmSqn2P4E=";

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
    "targetdir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Workspace Icons is a COSMIC panel applet that adds application icons to numbered workspaces.";
    homepage = "https://github.com/crocodile/cosmic-ext-applet-workspace-icons";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-applet-workspace-icons";
    maintainers = [ lib.maintainers.berrij ];
    platforms = lib.platforms.linux;
  };
})
