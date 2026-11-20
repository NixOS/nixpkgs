{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gate";
  version = "0.82.0";

  src = fetchFromGitHub {
    owner = "minekube";
    repo = "gate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZI4s1g/xX3E9HDt99WPhREqrtuOUvIO9JlXykzd1qqM=";
  };

  # go mod vendor fails on geyserlite and vialite: their optional //go:embed assets
  # (behind the geyserlite_embed and vialite_embed build tags) aren't in the modules
  proxyVendor = true;
  vendorHash = "sha256-3PRurHB8hY/nfumXXW8W4oW/TNA4r98rlc6ROFEd8iQ=";

  ldflags = [
    "-s"
    "-w"
    "-X go.minekube.com/gate/pkg/version.Version=${finalAttrs.version}"
  ];

  # tests bind UDP ports
  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      # these tests of upstream's CI and release scripts create helper scripts with a
      # /usr/bin/env shebang, which doesn't exist in the sandbox
      skippedTests = [
        "TestLintWrapperSelfTestRuns"
        "TestPublishImagesFailsClosedOnANonTransientFailure"
        "TestPublishImagesRetriesOnlyTheRegistryReadAfterWriteRace"
        "TestPublishImagesRetryIsBounded"
        "TestVerifyPublishedImagesIsFailClosed"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  # this test requires network access, therefore it should not be run
  preCheck = ''
    rm ./pkg/edition/bedrock/geyser/managed/download_test.go
  '';

  excludedPackages = [ ".web" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "High-Performance, Low-Memory, Lightweight, Extensible Minecraft Reverse Proxy";
    longDescription = ''
      Gate is an extensible, high performant & paralleled Minecraft proxy server
      with scalability, flexibility & excellent server version support - written in Go
      and ready for the cloud!
    '';
    homepage = "https://github.com/minekube/gate";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ XBagon ];
    mainProgram = "gate";
  };
})
