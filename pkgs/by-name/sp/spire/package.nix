{
  lib,
  buildGoModule,
  fetchFromGitHub,
  openssl,
}:

buildGoModule (finalAttrs: {
  pname = "spire";
  version = "1.13.3";

  outputs = [
    "out"
    "agent"
    "server"
    "oidc"
  ];

  src = fetchFromGitHub {
    owner = "spiffe";
    repo = "spire";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-Qph36DNnhZbO+bn1WnvBkWOWeCSusC0vrvZV1G32kFw=";
  };

  # Needed for github.co/google/go-tpm-tools/simulator  which contains non-go files that `go mod vendor` strips
  proxyVendor = true;
  vendorHash = "sha256-hkUA9L4lTSv7s/HtD1XOf07Hhk7ob2n/GCS+LnOSasI=";

  buildInputs = [ openssl ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/spiffe/spire/pkg/common/version.gittag=${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/spire-agent"
    "cmd/spire-server"
    "support/oidc-discovery-provider"
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
    # unset to run all tests
    unset subPackages
  '';

  # Usually either the agent or server is needed for a given use case, but not both
  postInstall = ''
    mkdir -vp $agent/bin $server/bin $oidc/bin
    mv -v $out/bin/spire-agent $agent/bin/
    mv -v $out/bin/spire-server $server/bin/
    mv -v $out/bin/oidc-discovery-provider $oidc/bin/

    ln -vs $agent/bin/spire-agent $out/bin/spire-agent
    ln -vs $server/bin/spire-server $out/bin/spire-server
    ln -vs $oidc/bin/oidc-discovery-provider $out/bin/oidc-discovery-provider
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    for bin in $out/bin/*; do
      $bin -h
      if [ "$($bin --version 2>&1)" != "${finalAttrs.version}" ]; then
        echo "$bin version does not match"
        exit 1
      fi
    done

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
      mjm
      arianvp
    ];
  };
})
