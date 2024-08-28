{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gatus";
  version = "5.12.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${version}";
    hash = "sha256-fxRHO37lxFb/rGr3TWLR817sNXaSClucuVtI1XgWrgM=";
  };

  vendorHash = "sha256-jRRFj4NdxsjC9CM+Vm5+gV0ZMbz45YtGyE3FaGaGp28=";

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
