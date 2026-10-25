{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gost";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "go-gost";
    repo = "gost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4c6x4NlAr79o7djGpyuLYg40VH3M3hp9MBQWLfPqzGQ=";
  };

  vendorHash = "sha256-KBOBJVkM2spogyGiLbnZMyZIJLohs1fwrQyKxJEuqnA=";

  # Based on ldflags in upstream's .goreleaser.yaml
  ldflags = [
    "-s"
    "-X main.version=v${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  # i/o timeout
  doCheck = !stdenv.hostPlatform.isDarwin;

  # Skip e2e tests that require a Docker daemon.
  excludedPackages = [ "tests/e2e" ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "-V";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple tunnel written in golang";
    homepage = "https://github.com/go-gost/gost";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pmy
      ramblurr
      moraxyc
    ];
    mainProgram = "gost";
  };
})
