{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "driftctl";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "driftctl";
    rev = "v${version}";
    sha256 = "sha256-Abp5JetsMqIXZK8BxNa22OBFCxquoLoy3npv6XxCWGo=";
  };

  vendorSha256 = "sha256-uWPnBqT6lZSRClw2RyxHEOzue1Azj9VpPaulMA3qlug=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/snyk/driftctl/pkg/version.version=v${version}"
    "-X github.com/snyk/driftctl/build.env=release"
    "-X github.com/snyk/driftctl/build.enableUsageReporting=false"
  ];

  postInstall = ''
    installShellCompletion --cmd driftctl \
      --bash <($out/bin/driftctl completion bash) \
      --fish <($out/bin/driftctl completion fish) \
      --zsh <($out/bin/driftctl completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/driftctl --help
    $out/bin/driftctl version | grep "v${version}"
    # check there's no telemetry flag
    $out/bin/driftctl --help | grep -vz "telemetry"

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://driftctl.com/";
    changelog = "https://github.com/snyk/driftctl/releases/tag/v${version}";
    description = "Detect, track and alert on infrastructure drift";
    longDescription = ''
      driftctl is a free and open-source CLI that warns of infrastructure drift
      and fills in the missing piece in your DevSecOps toolbox.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ kaction jk ];
  };
}
