{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  git,
  installShellFiles,
  openssl,
  net-tools,
  zstd,
}:

buildGoModule (finalAttrs: {
  pname = "grype";
  version = "0.111.1";

  # required for tests
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "anchore";
    repo = "grype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eAiExxvLFkHsmslfhhbQG0ogaSMF9eOeCq0u2wUimp0=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # 0000-00-00T00:00:00Z
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  proxyVendor = true;

  vendorHash = "sha256-rsdZt+xKjIJpWS5pYx8A+ryY1D2WIKquKjsQBkxToUQ=";

  patches = [
    # several test golden files have unstable paths based on the platform
    # this patch adjusts the `Redact` helper to also work for builds by nix.
    ./0001-test_helpers-redact-support-nix.patch
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    git
    openssl
    net-tools
    zstd
  ];

  subPackages = [ "cmd/grype" ];

  excludedPackages = "test/integration";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.gitDescription=v${finalAttrs.version}"
    "-X=main.gitTreeState=clean"
  ];

  preBuild = ''
    # grype version also displays the version of the syft library used
    # we need to grab it from the go.sum and add an ldflag for it
    SYFT_VERSION="$(grep "github.com/anchore/syft" go.sum -m 1 | awk '{print $2}')"
    ldflags+=" -X main.syftVersion=$SYFT_VERSION"
    ldflags+=" -X main.gitCommit=$(cat COMMIT)"
    ldflags+=" -X main.buildDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  preCheck = ''
    # test all dirs (except excluded)
    unset subPackages
    # test goldenfiles expect no version
    unset ldflags

    # patch utility script
    patchShebangs grype/db/v5/distribution/testdata/tls/generate-x509-cert-pair.sh
  '';

  checkFlags =
    let
      skippedTests = [
        # depend on docker
        "TestCmd"
        "TestSyftLocationExcludes"
        "Test_descriptorNameAndVersionSet"
        # depend on .git
        "Test_configLoading"
        "TestDBProviders"
        "TestDBValidations"
        "TestRegistryAuth"
        "TestRegistryAuthRedactions"
        "TestSBOMInput_FromStdin"
        "TestSBOMInput_AsArgument"
        "TestSubprocessStdin"
        "TestAllNames"
        "TestVersionCmdPrintsToStdout"
        "Test_SarifIsValid"
        "Test_dpkgUseCPEsForEOLEnvVar"
        "Test_rpmUseCPEsForEOLEnvVar"
      ]
      ++ lib.optionals stdenv.isDarwin [
        # fails to generate x509 certificate
        # cat: /etc/ssl/openssl.cnf: Operation not permitted
        "Test_defaultHTTPClientHasCert"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd grype \
      --bash <($out/bin/grype completion bash) \
      --fish <($out/bin/grype completion fish) \
      --zsh <($out/bin/grype completion zsh)
  '';

  meta = {
    description = "Vulnerability scanner for container images and filesystems";
    homepage = "https://github.com/anchore/grype";
    changelog = "https://github.com/anchore/grype/releases/tag/v${finalAttrs.version}";
    longDescription = ''
      As a vulnerability scanner grype is able to scan the contents of a
      container image or filesystem to find known vulnerabilities.
    '';
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [
      fab
      jk
      kashw2
    ];
    mainProgram = "grype";
  };
})
