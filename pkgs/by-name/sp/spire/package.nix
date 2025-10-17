{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "spire";
  version = "1.13.1";

  outputs = [
    "out"
    "agent"
    "server"
  ];

  src = fetchFromGitHub {
    owner = "spiffe";
    repo = "spire";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-1i2zT2oTJXMmISzUc4ixlZQjtjCcqUEi6RzgF9Zwm9s=";
  };

  vendorHash = "sha256-tho3Qm9uHiiSNFmBZGZFgxhAKD4HKWsIUmiqkWlToQk=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/spiffe/spire/pkg/common/version.gittag=${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/spire-agent"
    "cmd/spire-server"
  ];

  excludedPackages = [
    # ensure these files aren't evaluated, see preCheck
    "test/tmpsimulator"
    "pkg/agent/plugin/nodeattestor/tpmdevid"
  ];

  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      skippedTests = [
        # wants to reach remote TUF mirror
        "TestDockerConfig"
        "TestPlugin"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  preCheck = ''
    # remove test files which reference github.com/google/go-tpm-tools/simulator
    # since it requires cgo and some missing header files
    rm -rf test/tpmsimulator pkg/server/plugin/nodeattestor/tpmdevid/devid_test.go

    # unset to run all tests
    unset subPackages
  '';

  # Usually either the agent or server is needed for a given use case, but not both
  postInstall = ''
    mkdir -vp $agent/bin $server/bin
    mv -v $out/bin/spire-agent $agent/bin/
    mv -v $out/bin/spire-server $server/bin/

    ln -vs $agent/bin/spire-agent $out/bin/spire-agent
    ln -vs $server/bin/spire-server $out/bin/spire-server
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/spire-agent -h
    if [ "$($out/bin/spire-agent --version 2>&1)" != "${finalAttrs.version}" ]; then
      echo "spire-agent version does not match"
      exit 1
    fi

    $out/bin/spire-server -h
    if [ "$($out/bin/spire-server --version 2>&1)" != "${finalAttrs.version}" ]; then
      echo "spire-server version does not match"
      exit 1
    fi

    runHook postInstallCheck
  '';

  meta = {
    description = "SPIFFE Runtime Environment";
    homepage = "https://spiffe.io/";
    downloadPage = "https://github.com/spiffe/spire";
    changelog = "https://github.com/spiffe/spire/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fkautz
      jk
    ];
  };
})
