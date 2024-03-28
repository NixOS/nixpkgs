{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, openfga-cli
}:

buildGoModule rec {
  pname = "openfga-cli";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "openfga";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-zEJzj7zV8YJtNPQANuD+q/ffTuWc41W8mV6M4Efm4jw=";
  };

  vendorHash = "sha256-uulUNIxsDHiHSiXLUCSM09mDq4It4GyNZ2WvBzNmK2Q=";

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
