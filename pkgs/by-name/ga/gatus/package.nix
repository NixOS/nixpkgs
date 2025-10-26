{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "gatus";
  version = "5.28.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${version}";
    hash = "sha256-p60iqMzTch3dX+REaiKuLflIHLunGFI2JWx/TGo30g0=";
  };

  vendorHash = "sha256-vvYnNFRpDTaNBX30btvSrwmhimPobio/zAs7zQnZ7b8=";

  subPackages = [ "." ];

  passthru.tests = {
    inherit (nixosTests) gatus;
  };

  meta = with lib; {
    description = "Automated developer-oriented status page";
    homepage = "https://gatus.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ undefined-moe ];
    mainProgram = "gatus";
  };
}
