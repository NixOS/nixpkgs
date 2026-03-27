{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "buildkite-cli";
  version = "3.32.2";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7jBYi9KGkeB6Pu4VDR8QSTG3U4QFFVih3MUp2Sldpqo=";
  };

  vendorHash = "sha256-yi77gGlBIGEQQbYVVsQP74IVFuZo5GAPOdgYmaDnBAs=";

  ldflags = [
    "-s"
    "-X github.com/buildkite/cli/v3/cmd/version.Version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  checkFlags =
    let
      skippedTests = [
        # Require internet access
        "TestConversionAPIEndpoint"

        # Requires a git repository (which is removed by nix after fetching the source)
        "TestResolvePipelinesFromPath"
      ]
      ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
        # Expected timeout error but got none
        "TestPollJobStatus"
        "TestPollJobStatusTimeout"
      ];
    in
    [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
    ];

  __darwinAllowLocalNetworking = true;

  postInstall = ''
    mv $out/bin/cli $out/bin/bk
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line interface for Buildkite";
    homepage = "https://github.com/buildkite/cli";
    changelog = "https://github.com/buildkite/cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ groodt ];
    mainProgram = "bk";
  };
})
