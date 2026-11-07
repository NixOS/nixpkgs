{
  fetchFromGitHub,
  rustPlatform,
  lib,
  versionCheckHook,
  pkg-config,
  alsa-lib,
  wayland,
  libGL,
  libxkbcommon,
  libgcc,
  nix-update-script,
  autoPatchelfHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ruxguitar";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "agourlay";
    repo = "ruxguitar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HQin+2dA9RP92PFUZsmsXCIufnbmnxjbmk3pLFaZwtk=";
  };

  cargoHash = "sha256-3w1HXNAxI81cZiGsG9L+rSIKb5liJvKjggpPY5KVhmM=";

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
  ];
  buildInputs = [
    alsa-lib
    libgcc
  ];
  runtimeDependencies = [
    wayland
    libGL
    libxkbcommon
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "ruxguitar";
    description = "Guitar Pro tablature player";
    homepage = "https://github.com/agourlay/ruxguitar";
    changelog = "https://github.com/agourlay/ruxguitar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cilki ];
  };
})
