{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "misconfig-mapper";
  version = "1.13.7";

  src = fetchFromGitHub {
    owner = "intigriti";
    repo = "misconfig-mapper";
    tag = "v${version}";
    hash = "sha256-6WFtXIqnn2ayfXkGMIxGDlYpE3UbHRuAU8qHGk9SCU4=";
  };

  vendorHash = "sha256-fEmf+d9oBXz7KymNVmC+CM7OyPD9QV1uN4ReTNhei7A=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to uncover security misconfigurations on popular third-party services";
    homepage = "https://github.com/intigriti/misconfig-mapper";
    changelog = "https://github.com/intigriti/misconfig-mapper/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "misconfig-mapper";
  };
}
