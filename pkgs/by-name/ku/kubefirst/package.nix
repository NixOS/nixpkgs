{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubefirst";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "konstructio";
    repo = "kubefirst";
    tag = "v${version}";
    hash = "sha256-/DmYPxnqAoCPXjkaYTj1iYliNfqyqrDrChU6fCbbCkk=";
  };

  vendorHash = "sha256-1u34cuPUY/5fYd073UhRUu/5/1nhPadTI06+3o+uE7w=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/konstructio/kubefirst-api/configs.K1Version=v${version}"
  ];

  doCheck = false;

  meta = {
    description = "Tool to create instant GitOps platforms that integrate some of the best tools in cloud native from scratch";
    mainProgram = "kubefirst";
    homepage = "https://github.com/konstructio/kubefirst/";
    changelog = "https://github.com/konstructio/kubefirst/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qjoly ];
  };
}
