{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "misconfig-mapper";
  version = "1.14.14";

  src = fetchFromGitHub {
    owner = "intigriti";
    repo = "misconfig-mapper";
    tag = "v${version}";
    hash = "sha256-5tugmwr1TyBa89a/yrch+cshyoiJ3uj4EoweltN5d/0=";
  };

  vendorHash = "sha256-pLhc3Lc8Mp5ZRmNvac3qdQcw1rPQs7bbn4K0UHp04Qs=";

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
