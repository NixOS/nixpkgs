{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "postfix-tlspol";
  version = "1.8.8";

  src = fetchFromGitHub {
    owner = "Zuplu";
    repo = "postfix-tlspol";
    tag = "v${version}";
    hash = "sha256-XEQ2SOITUPmqI/+R7/O9ST5m5lHJT5fcBoBQk7GoOZM=";
  };

  vendorHash = null;

  # don't run tests, they perform checks via the network
  doCheck = false;

  ldflags = [ "-X main.Version=${version}" ];

  meta = {
    description = "Lightweight MTA-STS + DANE/TLSA resolver and TLS policy server for Postfix, prioritizing DANE.";
    homepage = "https://github.com/Zuplu/postfix-tlspol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ valodim ];
  };
}
