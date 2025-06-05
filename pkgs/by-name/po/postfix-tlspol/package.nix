{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "postfix-tlspol";
  version = "1.8.11";

  src = fetchFromGitHub {
    owner = "Zuplu";
    repo = "postfix-tlspol";
    tag = "v${version}";
    hash = "sha256-hQSJ0bp3ghfi5chislf2zuCrvPhhoA0jjChRdGYHcFY=";
  };

  vendorHash = null;

  # don't run tests, they perform checks via the network
  doCheck = false;

  ldflags = [ "-X main.Version=${version}" ];

  passthru.tests = {
    inherit (nixosTests) postfix-tlspol;
  };

  meta = {
    description = "Lightweight MTA-STS + DANE/TLSA resolver and TLS policy server for Postfix, prioritizing DANE.";
    homepage = "https://github.com/Zuplu/postfix-tlspol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ valodim ];
    mainProgram = "postfix-tlspol";
  };
}
