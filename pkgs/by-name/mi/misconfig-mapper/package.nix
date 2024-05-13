{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "misconfig-mapper";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "intigriti";
    repo = "misconfig-mapper";
    rev = "refs/tags/v${version}";
    hash = "sha256-5FzXtqC8C4iDC8xBalKHlNeSIJ0msMVC7jUXZxSLkLY=";
  };

  vendorHash = "sha256-b2AVWjZXNQPV84sS2wu5xUadZEme/T96O4dGiV5G0dA=";

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
