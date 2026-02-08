{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "misconfig-mapper";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "intigriti";
    repo = "misconfig-mapper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CSUE6M8sT1kWR3jkbPtXUIvkqlmDJ3XPFD3yHGJZ/ic=";
  };

  vendorHash = "sha256-N0lFTfHtzOH1zJIYXRzKJ8KNpcMgUBuVrsr+RzzylKY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to uncover security misconfigurations on popular third-party services";
    homepage = "https://github.com/intigriti/misconfig-mapper";
    changelog = "https://github.com/intigriti/misconfig-mapper/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "misconfig-mapper";
  };
})
