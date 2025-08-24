{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "pack";
  version = "0.38.2";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = "pack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JDvNG0HMwr/bbWbuSLwuC5y+ZePECW4u+dzMBcKrcNk=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-PvGoHJP+MsfidKz72qFx638x+uirhgckIKCBdTUrqB8=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/buildpacks/pack/pkg/client.Version=${finalAttrs.version}"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "CLI for building apps using Cloud Native Buildpacks";
    homepage = "https://github.com/buildpacks/pack/";
    license = lib.licenses.asl20;
    mainProgram = "pack";
    maintainers = with lib.maintainers; [ ];
  };
})
