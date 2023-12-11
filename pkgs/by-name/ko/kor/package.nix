{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kor";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ov+aad+6Tp6Mm+fyjR9+xTYVlRu7uv1kD14AgSFmPMA=";
  };

  vendorHash = "sha256-HPcLjeLw3AxqZg2f5v5G4uYX65D7yXaXDZUPUgWnLFA=";

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
