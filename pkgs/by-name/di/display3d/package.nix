{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "display3d";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "renpenguin";
    repo = "display3d";
    tag = "v${version}";
    hash = "sha256-dFfU80/1fhBz9/0fVZigo+nZx6Lj66OsP52oMDpS+BY=";
  };

  cargoHash = "sha256-eXpoWKYonNZQqqIFrxO4RnLLX1s1osaZxZt3gVTYd4o=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for rendering and animating 3D objects";
    homepage = "https://github.com/renpenguin/display3d";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ renpenguin ];
    mainProgram = "display3d";
  };
}
