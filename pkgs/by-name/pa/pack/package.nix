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
  version = "0.40.2";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = "pack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fFNC0U9pxZ2iaYEf5FQcVQJF1B/2P9UxQdeNqt7r+UI=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-Mawgo6ppIfifNh0xGHxN6jRq07PeghcDOhekexQFPas=";

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
