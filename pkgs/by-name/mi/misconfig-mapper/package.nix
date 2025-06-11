{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "misconfig-mapper";
  version = "1.14.4";

  src = fetchFromGitHub {
    owner = "intigriti";
    repo = "misconfig-mapper";
    tag = "v${version}";
    hash = "sha256-HLGBQugGg66wH3NFPDvFRRGdDscd+Vz6LHG8CYHqgYw=";
  };

  vendorHash = "sha256-GY3eRMj7YtuP/Bibf2e4fAOwGNe9TTadmOBpOxK4S6c=";

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
