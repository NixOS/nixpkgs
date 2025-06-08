{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "dalfox";
    tag = "v${version}";
    hash = "sha256-EM5T8uBMSkjxd7wTaMFPpbErAhcN2oLaV2g8MAxb0lQ=";
  };

  vendorHash = "sha256-EgNE3Z/NZ1lV0BPVe4MhB9bIYSMLftzYfmw65ktSo7A=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    changelog = "https://github.com/hahwul/dalfox/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dalfox";
  };
}
