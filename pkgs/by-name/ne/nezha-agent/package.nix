{
  lib,
  buildGoModule,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "nezha-agent";
  version = "0.20.3";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "agent";
    rev = "refs/tags/v${version}";
    hash = "sha256-cLLiJbAr7TxVUNV31Y9TG8ZL4uqBCOnrOr1FM4+1U5c=";
  };

  vendorHash = "sha256-q6/265vVg6jCnDvs825nni8QFHkJpQz4xxC9MlJH2do=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
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

  meta = {
    description = "Agent of Nezha Monitoring";
    homepage = "https://github.com/nezhahq/agent";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nezha-agent";
  };
}
