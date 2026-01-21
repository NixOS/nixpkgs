{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "infracost";
  version = "0.10.43";

  src = fetchFromGitHub {
    owner = "infracost";
    rev = "v${version}";
    repo = "infracost";
    sha256 = "sha256-02HQp11MfUKK0tXcBRmGqatG5C7462VEWtHHCjLv32I=";
  };
  vendorHash = "sha256-cNL68orv14HhzwsuaqzfDbVnBsMNE3Lu4EiCvKQhgpM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/infracost/infracost/internal/version.Version=v${version}"
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
    $out/bin/infracost --version | grep "v${version}"

    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://infracost.io";
    changelog = "https://github.com/infracost/infracost/releases/tag/v${version}";
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
}
