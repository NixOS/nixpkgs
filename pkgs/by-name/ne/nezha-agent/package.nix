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
  version = "0.20.5";

  src = fetchFromGitHub {
    owner = "nezhahq";
    repo = "agent";
    rev = "refs/tags/v${version}";
    hash = "sha256-CVE1c0LLheGlH8oMWQWs6fox7mlHc5Y2O9XQ6kqXAwI=";
  };

  vendorHash = "sha256-ytFsTHl6kVwmqCabaMDxxijszY3jzWWUIZKBCebPMkI=";

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
