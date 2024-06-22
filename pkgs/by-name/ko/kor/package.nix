{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kor";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5x0Zyk4gPMKcZtpgT0QbIm6NeWX+uJwT2NM+yS2oC3o=";
  };

  vendorHash = "sha256-9aZy1i0VrDRySt5A5aQHBXa0mPgD+rsyeqQrd6snWKc=";

  preCheck = ''
    HOME=$(mktemp -d)
    export HOME
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Golang Tool to discover unused Kubernetes Resources";
    homepage = "https://github.com/yonahd/kor";
    changelog = "https://github.com/yonahd/kor/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.ivankovnatsky ];
    mainProgram = "kor";
  };
}
