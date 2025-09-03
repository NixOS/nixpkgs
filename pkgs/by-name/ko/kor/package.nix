{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kor";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = "kor";
    rev = "v${version}";
    hash = "sha256-hGiak28gwxwYOogYyZjTgQ+aGSumxzeZiQKlbVvvrIU=";
  };

  vendorHash = "sha256-a7B0cJi71mqGDPbXaWYKZ2AeuuQyNDxwWNgahTN5AW8=";

  preCheck = ''
    HOME=$(mktemp -d)
    export HOME
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Golang Tool to discover unused Kubernetes Resources";
    homepage = "https://github.com/yonahd/kor";
    changelog = "https://github.com/yonahd/kor/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ivankovnatsky ];
    mainProgram = "kor";
  };
}
