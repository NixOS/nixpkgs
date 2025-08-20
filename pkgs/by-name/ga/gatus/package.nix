{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:
buildGoModule rec {
  pname = "gatus";
  version = "5.18.1";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${version}";
    hash = "sha256-pLl1rZhxsErZinbCFfXeDtj3gBSphPPznHq54XSR5M8=";
  };

  vendorHash = "sha256-5e4+U7nksU2Xkdw84M/GY+LvD5LrfCSKqzFHSQQUwY8=";

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
