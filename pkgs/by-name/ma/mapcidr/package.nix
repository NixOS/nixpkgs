{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mapcidr";
  version = "1.1.97";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "mapcidr";
    tag = "v${version}";
    hash = "sha256-a+yVSh+Cgq73mQHaumVgNqEg/gXa2r2qld4bTi3Du/Y=";
  };

  vendorHash = "sha256-4gzxKmnl8MOPcdzkwhReZ/cfbjfICY9kxousveoHYR0=";

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
