{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubefirst";
  version = "2.7.9";

  src = fetchFromGitHub {
    owner = "konstructio";
    repo = "kubefirst";
    rev = "refs/tags/v${version}";
    hash = "sha256-nBYwvOgkkx3NXELK+h9SpapoMjAVauI9leCPhKNZfh0=";
  };

  vendorHash = "sha256-DYEEkduud1sXVao7xbJoyvmMhfMJUPswIs3v20tncwo=";

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
