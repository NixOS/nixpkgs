{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mapcidr";
  version = "1.1.96";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "mapcidr";
    tag = "v${version}";
    hash = "sha256-wEx1HDMl2y3di3k5Mb4lnX5adYYd7wPyaF2bw+5ivSY=";
  };

  vendorHash = "sha256-W647ne516UVhQ3ctrr+LsAEwzxeVHBjshW1pG1Wb/gU=";

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
