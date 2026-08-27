{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "display3d";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "renpenguin";
    repo = "display3d";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f2iT+3xqtFY8e9kmwpEac0/WQLFVL6tXUk/lQgBQzaM=";
  };

  cargoHash = "sha256-IEaiehlOCQGun/CUIbPlCITAm6L/XV1uyQSmlBPnxGk=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for rendering and animating 3D objects";
    homepage = "https://github.com/renpenguin/display3d";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ renpenguin ];
    mainProgram = "display3d";
  };
})
