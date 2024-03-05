{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kor";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Y8k7tpKqs/X5ePa2kFkKxrYb1E4Z5h8+o229eD6YQ/M=";
  };

  vendorHash = "sha256-DRbwM6fKTIlefD0rUmNLlUXrK+t3vNCl4rxHF7m8W10=";

  preCheck = ''
    HOME=$(mktemp -d)
    export HOME
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "A Golang Tool to discover unused Kubernetes Resources";
    homepage = "https://github.com/yonahd/kor";
    changelog = "https://github.com/yonahd/kor/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.ivankovnatsky ];
    mainProgram = "kor";
  };
}
