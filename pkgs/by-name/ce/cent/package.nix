{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cent";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "xm1k3";
    repo = "cent";
    rev = "refs/tags/v${version}";
    hash = "sha256-E3gAtrgWVucV3cD31ntgtdTDkhmqJHOiFwaUdVJj0jQ=";
  };

  vendorHash = "sha256-LvI9FJFXBnEXNsX3qp2Sl58ccIJtYDGSEtNUwNW/Pp0=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to handle Nuclei community templates";
    homepage = "https://github.com/xm1k3/cent";
    changelog = "https://github.com/xm1k3/cent/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "cent";
  };
}
