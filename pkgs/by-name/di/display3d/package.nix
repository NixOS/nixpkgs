{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "display3d";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "renpenguin";
    repo = "display3d";
    tag = "v${version}";
    hash = "sha256-WGcocX3WYtTleh2f3F0yi3KBAMo1/dtlfVy1pQVhWgw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-E4Ncg9OPlYGra794pPS9u9oyqep+k3Ser5ZxfV+uSRM=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "CLI for rendering and animating 3D objects";
    homepage = "https://github.com/renpenguin/display3d";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ renpenguin ];
    mainProgram = "display3d";
  };
}
