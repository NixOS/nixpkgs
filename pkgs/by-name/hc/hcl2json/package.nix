{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hcl2json";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zd8+ZDuC+qBienADiTVhW8o+BH8spBTCDHIK2PwK3YY=";
  };

  vendorHash = "sha256-GMy6jGXAjykg+61RbPbQ9ZI0odhPls6uLhtw2sKLUmY=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert hcl2 to json";
    homepage = "https://github.com/tmccombs/hcl2json";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "hcl2json";
  };
}
