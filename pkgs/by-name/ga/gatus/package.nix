{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "gatus";
  version = "5.17.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${version}";
    hash = "sha256-/YOC13ut1k48vx/LapcShNfi83LxbC62yxKuanlUI9k=";
  };

  vendorHash = "sha256-gr/GmZaaNwp/jQwnDiU/kfDWaciQloxP9vNlVTwMQjE=";

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
