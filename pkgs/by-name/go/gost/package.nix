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
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "go-gost";
    repo = "gost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+g8YjOuH1WKfEYPLbrKB2YIHnY7HXJv0rQfxiL/jdQI=";
  };

  vendorHash = "sha256-lEPJpOXyPiMbFEbVlMGdhBGRYj5JTx2zun7YmX19r4k=";

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
