{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gatus";
  version = "5.9.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${version}";
    hash = "sha256-obrdEnNxLdWtbGL57D/nTClaOdzJlLDU3+K9VdR8XI4=";
  };

  vendorHash = "sha256-VICVo7XYeHs/43knHA4CMSgHloyYSjOFe1TUb4u+egE=";

  subPackages = [ "." ];

  meta = with lib;
    {
      description = "Automated developer-oriented status page";
      homepage = "https://gatus.io";
      license = licenses.asl20;
      maintainers = with maintainers; [ undefined-moe ];
      mainProgram = "gatus";
    };
}
