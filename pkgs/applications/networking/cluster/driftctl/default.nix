{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "driftctl";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "driftctl";
    rev = "v${version}";
    sha256 = "sha256-TUwTvCsWB+n+shVU1hTzLYROG9Wp4ySzJwAnappK7TY=";
  };

  vendorSha256 = "sha256-I0OCRhUvuaF4k5qqPaV6R24mrd9AG5GgQCCF6yodK0E=";

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
