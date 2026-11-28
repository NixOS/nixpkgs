{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "podman-tui";
  version = "2.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-01W3iG7WOKNKVMEjP4o53TiDOVqge91IrUWCx0hEUsQ=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;

  tags = [
    "containers_image_openpgp"
    "remote"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "darwin";

  ldflags = [ "-s" ];

  checkFlags =
    let
      skippedTests = [
        # Disable flaky tests
        "TestDialogs"
        "TestVoldialogs"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "version";

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/containers/podman-tui";
    changelog = "https://github.com/containers/podman-tui/releases/tag/${finalAttrs.src.tag}";
    description = "Podman Terminal UI";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "podman-tui";
  };
})
