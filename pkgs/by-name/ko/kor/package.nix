{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kor";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = "kor";
    rev = "v${version}";
    hash = "sha256-/UeZBFLSAR6hnXGQyOV6Y7O7PaG7tXelyqS6SeFN+3M=";
  };

  vendorHash = "sha256-VJ5Idm5p+8li5T7h0ueLIYwXKJqe6uUZ3dL5U61BPFg=";

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
