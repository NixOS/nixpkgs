{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "misconfig-mapper";
  version = "1.14.9";

  src = fetchFromGitHub {
    owner = "intigriti";
    repo = "misconfig-mapper";
    tag = "v${version}";
    hash = "sha256-4d7/RxL8+ZJXnoU2zOl6W6f5/KsuqrS95IYttC81zVA=";
  };

  vendorHash = "sha256-2DlhNr1P6NEeV5IIum19LWufFlOcXxfLH93k3jkwnDA=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to uncover security misconfigurations on popular third-party services";
    homepage = "https://github.com/intigriti/misconfig-mapper";
    changelog = "https://github.com/intigriti/misconfig-mapper/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "misconfig-mapper";
  };
}
