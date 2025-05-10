{
  lib,
  buildGoModule,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule rec {
  pname = "nezha-agent";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "agent";
    tag = "v${version}";
    hash = "sha256-Pmfq9yk78mesxSzg7YdrL8KjHL6vRHPrAuNM7StRmus=";
  };

  vendorHash = "sha256-g7F/kkA9BXJj8oTFt0IrvloOyGNIE//tQg+ND7aJokg=";

  ldflags = [
    "-s"
    "-X github.com/nezhahq/agent/pkg/monitor.Version=${version}"
    "-X main.arch=${stdenv.hostPlatform.system}"
  ];

  preBuild = ''
    go generate ./...
  '';

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
}
