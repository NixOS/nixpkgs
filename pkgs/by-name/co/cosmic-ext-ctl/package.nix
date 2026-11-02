{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  cosmic-comp,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-ext-ctl";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v3lNcXvSbTtCCosPD0z5ubksrBF9b0ATWfmLfF6MzvI=";
  };

  cargoHash = "sha256-lRBkcn4Vy7XGRpymT3KCeHWwR3hXK5LxTDZB+Kiuk7E=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/cosmic-ctl";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for COSMIC Desktop configuration management";
    changelog = "https://github.com/cosmic-utils/cosmic-ctl/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/cosmic-utils/cosmic-ctl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    mainProgram = "cosmic-ctl";
    inherit (cosmic-comp.meta) platforms;
  };
})
