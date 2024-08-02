{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cent";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "xm1k3";
    repo = "cent";
    rev = "refs/tags/v${version}";
    hash = "sha256-xwGmBZgdpyYJ1AKoNUUPEMbU5/racalE4SLrx/E51wM=";
  };

  vendorHash = "sha256-GMnTIEnkOt0cRN9pZzEuqqtWmO27uVja9VG5UNeCHJo=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to handle Nuclei community templates";
    homepage = "https://github.com/xm1k3/cent";
    changelog = "https://github.com/xm1k3/cent/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "cent";
  };
}
