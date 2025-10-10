{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mapcidr";
  version = "1.1.95";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "mapcidr";
    tag = "v${version}";
    hash = "sha256-u3PWmevFELltq28Kdx7QV1yYBOXudWR6tdRbzfJf3Aw=";
  };

  vendorHash = "sha256-zPRl40Ex/tBAW32fJ+oqJyXOuDTuWJfG6wHTYUu1ZUE=";

  modRoot = ".";
  subPackages = [
    "cmd/mapcidr"
  ];

  meta = {
    description = "Small utility program to perform multiple operations for a given subnet/CIDR ranges";
    longDescription = ''
      mapCIDR is developed to ease load distribution for mass scanning
      operations, it can be used both as a library and as independent CLI tool.
    '';
    homepage = "https://github.com/projectdiscovery/mapcidr";
    changelog = "https://github.com/projectdiscovery/mapcidr/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hanemile ];
    mainProgram = "mapcidr";
  };
}
