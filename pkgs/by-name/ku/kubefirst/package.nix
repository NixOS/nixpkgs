{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubefirst";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "konstructio";
    repo = "kubefirst";
    tag = "v${version}";
    hash = "sha256-dNHHanoPR+U7WvjDSfEWOYbZAcWjt4fla8jMZAahJaE=";
  };

  vendorHash = "sha256-tpg36+yiXAl2WD3JlfN9tPrTKk9B5aRpcx6dCAJNf70=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/konstructio/kubefirst-api/configs.K1Version=v${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Tool to create instant GitOps platforms that integrate some of the best tools in cloud native from scratch";
    mainProgram = "kubefirst";
    homepage = "https://github.com/konstructio/kubefirst/";
    changelog = "https://github.com/konstructio/kubefirst/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ qjoly ];
  };
}
