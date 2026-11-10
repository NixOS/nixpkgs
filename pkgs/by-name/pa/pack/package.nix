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
  version = "0.40.10";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = "pack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IRNtF09I9R6X1s5oRiUH31A+BIjZ3fSXq5yVSwXTceA=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-mUfLk5teaJswky7ipTiPWfDeaAk6B7yq0E7mI19e6D4=";

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
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "CLI for building apps using Cloud Native Buildpacks";
    homepage = "https://github.com/buildpacks/pack/";
    license = lib.licenses.asl20;
    mainProgram = "pack";
    maintainers = [ ];
  };
})
