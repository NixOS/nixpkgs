{
  lib,
  buildGoModule,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "nezha-agent";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DW82DWoUTPfT/yGiim++uAwBpOdIZpgs1bo9DKKtjzY=";
  };

  vendorHash = "sha256-/P2emb7AgKQz7tOnnsKm5udmxduqgdbYB97x6QkdDBU=";

  ldflags = [
    "-s"
    "-X github.com/nezhahq/agent/pkg/monitor.Version=${finalAttrs.version}"
    "-X main.arch=${stdenv.hostPlatform.system}"
  ];

  # some tests bind to localhost
  __darwinAllowLocalNetworking = true;
  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestLookupIP"
        "TestGeoIPApi"
        "TestFetchGeoIP"
        "TestCloudflareDetection"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        # os/user.Current() cannot resolve the Nix build UID
        "TestTask_RejectsMalformedFrame_OpOnlyCommandsUseLegacyBehavior/list_falls_back_to_home_directory"
        # macOS system certificate verification (trustd) is unavailable in the Nix sandbox (OSStatus -26276)
        "TestUTLSRoundTripperRejectsUntrustedServerCertificate"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    pushd $out/bin
    mv agent nezha-agent

    # for compatibility
    ln -sr nezha-agent agent
    popd
  '';

  doInstallCheck = true;

  versionCheckProgramArg = "-v";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Agent of Nezha Monitoring";
    homepage = "https://github.com/nezhahq/agent";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nezha-agent";
  };
})
