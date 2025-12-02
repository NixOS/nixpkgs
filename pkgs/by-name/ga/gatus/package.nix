{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "gatus";
  version = "5.31.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${version}";
    hash = "sha256-thLS6pAlnu7XcQHritr28CnzmpIOgIcEPIch2IwhZfQ=";
  };

  vendorHash = "sha256-VaD/cTf9D00gr6+9gKadK4aTwqhmJN/+cohwNvckxyw=";

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
