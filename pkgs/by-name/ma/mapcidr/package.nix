{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mapcidr";
  version = "1.1.34";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "mapcidr";
    tag = "v${version}";
    hash = "sha256-/bZ6LimkdbR7nG7XcetNshk0KXw1FGbuaTXP+DH7hQg=";
  };

  vendorHash = "sha256-tbMCXNBND9jc0C1bA9Rmz1stYKtJPmMzTlbGc3vcmE4=";

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
