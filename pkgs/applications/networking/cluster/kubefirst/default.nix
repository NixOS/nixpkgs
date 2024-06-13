{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubefirst";
  version = "2.4.9";

  src = fetchFromGitHub {
    owner = "kubefirst";
    repo = "kubefirst";
    rev = "refs/tags/v${version}";
    hash = "sha256-BuGE+SVLklToKnH7pptfuHqwddncUQq523RZtfmtkLg=";
  };

  vendorHash = "sha256-ZcZl4knlyKAwTsiyZvlkN5e2ox30B5aNzutI/2UEE9U=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/kubefirst/runtime/configs.K1Version=v${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Tool to create instant GitOps platforms that integrate some of the best tools in cloud native from scratch";
    mainProgram = "kubefirst";
    homepage = "https://github.com/kubefirst/kubefirst/";
    changelog = "https://github.com/kubefirst/kubefirst/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ qjoly ];
  };
}
