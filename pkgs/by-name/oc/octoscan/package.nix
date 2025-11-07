{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "octoscan";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "synacktiv";
    repo = "octoscan";
    tag = "v${version}";
    hash = "sha256-BFq4PXW5V8L4NP6wn2t2hG5xBKwxlgS+YC75VDTKKjs=";
  };

  vendorHash = "sha256-+TQDZXqWNBFAPES0qsrpBdl/jQZAfHXBcav2HcS0d7o=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Static vulnerability scanner for GitHub action workflows";
    homepage = "https://github.com/synacktiv/octoscan";
    changelog = "https://github.com/synacktiv/octoscan/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "octoscan";
  };
}
