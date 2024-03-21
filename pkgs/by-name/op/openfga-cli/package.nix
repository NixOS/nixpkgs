{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, openfga-cli
}:

buildGoModule rec {
  pname = "openfga-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "openfga";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-bRDaUPWzCGRV824ncx6G/+kx66XRcLiui6h22qWDEYk=";
  };

  vendorHash = "sha256-WCFNO1mign4u0dnvGs7qQcXUFB29zC6bjRiPVXNC30M=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/openfga/cli/internal/build.Version=${version}"
    "-X=github.com/openfga/cli/internal/build.Commit=${src.rev}"
    "-X=github.com/openfga/cli/internal/build.Date="
  ];

  subPackages = [ "cmd/fga" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd fga \
      --bash <($out/bin/fga completion bash) \
      --fish <($out/bin/fga completion fish) \
      --zsh <($out/bin/fga completion zsh)
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = openfga-cli;
      version = src.rev;
      command = "fga version";
    };
  };

  meta = with lib; {
    description = "A cross-platform CLI to interact with an OpenFGA server";
    homepage = "https://github.com/openfga/cli";
    changelog = "https://github.com/openfga/cli/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "fga";
  };
}
