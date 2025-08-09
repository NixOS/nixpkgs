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
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CFwHMO78v/A5hjNypFo9Fp0gdkrKgNvPRGz3RfMRRAU=";
  };

  vendorHash = "sha256-5g2AgkqaelCD10dxwcEmBLYy5nrd4IALiss0dTrTTno=";

  ldflags = [
    "-s"
    "-X github.com/nezhahq/agent/pkg/monitor.Version=${finalAttrs.version}"
    "-X main.arch=${stdenv.hostPlatform.system}"
  ];

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestLookupIP"
        "TestGeoIPApi"
        "TestFetchGeoIP"
        "TestCloudflareDetection"
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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nezha-agent";
  };
})
