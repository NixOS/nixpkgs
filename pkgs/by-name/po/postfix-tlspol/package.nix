{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "postfix-tlspol";
  version = "1.8.19";

  src = fetchFromGitHub {
    owner = "Zuplu";
    repo = "postfix-tlspol";
    tag = "v${version}";
    hash = "sha256-DSkWE76GSQKkrXAlnMvjTPAa4I4J07mZL9eea06Dzb8=";
  };

  vendorHash = null;

  # don't run tests, they perform checks via the network
  doCheck = false;

  ldflags = [ "-X main.Version=${version}" ];

  passthru.tests = {
    inherit (nixosTests) postfix-tlspol;
  };

  meta = {
    changelog = "https://github.com/Zuplu/postfix-tlspol/releases/tag/${src.tag}";
    description = "Lightweight MTA-STS + DANE/TLSA resolver and TLS policy server for Postfix, prioritizing DANE.";
    homepage = "https://github.com/Zuplu/postfix-tlspol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hexa
      valodim
    ];
    mainProgram = "postfix-tlspol";
  };
}
