{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "infracost";
  version = "0.10.46";

  src = fetchFromGitHub {
    owner = "infracost";
    rev = "v${finalAttrs.version}";
    repo = "infracost";
    sha256 = "sha256-4a29Lu5ShQpM3TfCXh0rA5gtO22MyT6/G2y3C4F3iyo=";
  };
  vendorHash = "sha256-4s6SAVgEmkwGvt08vsTw+qc0yFK+HtpCUkPkVUZzQUg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/infracost/infracost/internal/version.Version=v${finalAttrs.version}"
  ];

  subPackages = [ "cmd/infracost" ];

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    # Feed in all tests for testing
    # This is because subPackages above limits what is built to just what we
    # want but also limits the tests
    unset subPackages

    # remove tests that require networking
    rm cmd/infracost/{breakdown,comment,diff,hcl,run,upload}_test.go
    rm cmd/infracost/comment_{azure_repos,bitbucket,github,gitlab}_test.go
    rm internal/providers/terraform/hcl_provider_test.go
  '';

  checkFlags = [
    "-short"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export INFRACOST_SKIP_UPDATE_CHECK=true
    installShellCompletion --cmd infracost \
      --bash <($out/bin/infracost completion --shell bash) \
      --fish <($out/bin/infracost completion --shell fish) \
      --zsh <($out/bin/infracost completion --shell zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export INFRACOST_SKIP_UPDATE_CHECK=true
    $out/bin/infracost --help
    $out/bin/infracost --version | grep "v${finalAttrs.version}"

    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://infracost.io";
    changelog = "https://github.com/infracost/infracost/releases/tag/v${finalAttrs.version}";
    description = "Cloud cost estimates for Terraform in your CLI and pull requests";
    longDescription = ''
      Infracost shows hourly and monthly cost estimates for a Terraform project.
      This helps developers, DevOps et al. quickly see the cost breakdown and
      compare different deployment options upfront.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      davegallant
      jk
      kashw2
    ];
    mainProgram = "infracost";
  };
})
