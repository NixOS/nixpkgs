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
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = "pack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-20IHV389nnlPDtQcFboi6Mw9IlC1riDruD+rzmpl9RY=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-DRpKX57kk8D2DaA6S/QNmh8sl27yJy+XrVUIX9vuMV4=";

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
    maintainers = [ ];
  };
})
