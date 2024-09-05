{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubefirst";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "kubefirst";
    repo = "kubefirst";
    rev = "refs/tags/v${version}";
    hash = "sha256-1VadsiZZii6gI8vdTNfwmbBPuHcgPh4kWZ2jf/EkFKU=";
  };

  vendorHash = "sha256-tOCVDp9oClfeBsyZ6gv6HoGPjZByoxxAceV/wxQeBSA=";

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
