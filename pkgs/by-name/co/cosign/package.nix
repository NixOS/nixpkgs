{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  pcsclite,
  pkg-config,
  installShellFiles,
  pivKeySupport ? true,
  pkcs11Support ? true,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "cosign";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = "cosign";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JQxVO7wZFyRovst3qb0EErDyIIhPNsIpBq/iQVf6djY=";
  };

  buildInputs = lib.optional (stdenv.hostPlatform.isLinux && pivKeySupport) (lib.getDev pcsclite);

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  vendorHash = "sha256-7qVJMQI5htqMavrxFP2lQfQ/7b27bRWnNYg2cHmTZYE=";

  subPackages = [
    "cmd/cosign"
  ];

  tags =
    [ ] ++ lib.optionals pivKeySupport [ "pivkey" ] ++ lib.optionals pkcs11Support [ "pkcs11key" ];

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=v${finalAttrs.version}"
    "-X sigs.k8s.io/release-utils/version.gitTreeState=clean"
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    # test all paths
    unset subPackages
  '';

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestLoadCertsKeylessVerification/default_fulcio"
        "TestGetCTLogPubKeys"
        "TestGetRekorPubKeys"
        "TestVerifyEmbeddedSCT"
        "TestValidateAndUnpackCertWithSCT"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cosign \
      --bash <($out/bin/cosign completion bash) \
      --fish <($out/bin/cosign completion fish) \
      --zsh <($out/bin/cosign completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "cosign version";
    version = "v${finalAttrs.version}";
  };

  meta = with lib; {
    homepage = "https://github.com/sigstore/cosign";
    changelog = "https://github.com/sigstore/cosign/releases/tag/v${finalAttrs.version}";
    description = "Container Signing CLI with support for ephemeral keys and Sigstore signing";
    mainProgram = "cosign";
    license = licenses.asl20;
    maintainers = with maintainers; [
      lesuisse
      jk
      developer-guy
    ];
  };
})
