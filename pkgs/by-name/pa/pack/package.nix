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
  version = "0.40.1";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = "pack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2/M+3LhsXhZUp42YC7G8CCs8CUtCobeSFIQsYXRPc58=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-13TM77QzzeXc6lG1twt5UuBeu9oDHPlgop3PuBlNcRY=";

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
