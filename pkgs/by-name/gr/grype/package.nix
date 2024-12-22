{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  installShellFiles,
  openssl,
}:

buildGoModule rec {
  pname = "grype";
  version = "0.81.0";

  src = fetchFromGitHub {
    owner = "anchore";
    repo = "grype";
    rev = "refs/tags/v${version}";
    hash = "sha256-iFPUvqdYjSlrGlDrrb0w1HNeU5iAQ7PD4ojeZT3pHZ8=";
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

  vendorHash = "sha256-PXx5SyuKvxOZwJBspIiL8L7QzXzort6ZU3ZfrE8o700=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    git
    openssl
  ];

  subPackages = [ "cmd/grype" ];

  excludedPackages = "test/integration";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.gitDescription=v${version}"
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
    patchShebangs grype/db/test-fixtures/tls/generate-x509-cert-pair.sh

    # remove tests that depend on docker
    substituteInPlace test/cli/cmd_test.go \
      --replace-fail "TestCmd" "SkipCmd"
    substituteInPlace grype/pkg/provider_test.go \
      --replace-fail "TestSyftLocationExcludes" "SkipSyftLocationExcludes"
    substituteInPlace test/cli/cmd_test.go \
      --replace-fail "Test_descriptorNameAndVersionSet" "Skip_descriptorNameAndVersionSet"
    # remove tests that depend on git
    substituteInPlace test/cli/db_validations_test.go \
      --replace-fail "TestDBValidations" "SkipDBValidations"
    substituteInPlace test/cli/registry_auth_test.go \
      --replace-fail "TestRegistryAuth" "SkipRegistryAuth"
    substituteInPlace test/cli/sbom_input_test.go \
      --replace-fail "TestSBOMInput_FromStdin" "SkipSBOMInput_FromStdin" \
      --replace-fail "TestSBOMInput_AsArgument" "SkipSBOMInput_AsArgument"
    substituteInPlace test/cli/subprocess_test.go \
      --replace-fail "TestSubprocessStdin" "SkipSubprocessStdin"
    substituteInPlace grype/internal/packagemetadata/names_test.go \
      --replace-fail "TestAllNames" "SkipAllNames"
    substituteInPlace test/cli/version_cmd_test.go \
      --replace-fail "TestVersionCmdPrintsToStdout" "SkipVersionCmdPrintsToStdout"
    substituteInPlace grype/presenter/sarif/presenter_test.go \
      --replace-fail "Test_SarifIsValid" "SkipTest_SarifIsValid"

    # May fail on NixOS, probably due bug in how syft handles tmpfs.
    # See https://github.com/anchore/grype/issues/1822
    substituteInPlace grype/distro/distro_test.go \
      --replace-fail "Test_NewDistroFromRelease_Coverage" "SkipTest_NewDistroFromRelease_Coverage"

    # segfault
    rm grype/db/v5/namespace/cpe/namespace_test.go
  '';

  postInstall = ''
    installShellCompletion --cmd grype \
      --bash <($out/bin/grype completion bash) \
      --fish <($out/bin/grype completion fish) \
      --zsh <($out/bin/grype completion zsh)
  '';

  meta = with lib; {
    description = "Vulnerability scanner for container images and filesystems";
    homepage = "https://github.com/anchore/grype";
    changelog = "https://github.com/anchore/grype/releases/tag/v${version}";
    longDescription = ''
      As a vulnerability scanner grype is able to scan the contents of a
      container image or filesystem to find known vulnerabilities.
    '';
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [
      fab
      jk
      kashw2
    ];
    mainProgram = "grype";
  };
}
