{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "dalfox";
    tag = "v${version}";
    hash = "sha256-F4CXVgHdEjSMK3YIF5X6zCVVI17GkIE3KGAE1OxfhyY=";
  };

  vendorHash = "sha256-Nt0Rgwrjs2irKPnt5G/32VH3Wj19+xnh+gLspWDnKCY=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    changelog = "https://github.com/hahwul/dalfox/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "dalfox";
  };
}
