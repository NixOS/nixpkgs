{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.20";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-JjpfNQsqtmSKXj14fQUJsiTgfkAlSHDfqUC/x+bE+fc=";
  };
  vendorHash = "sha256-dZjsYqw/ABEn1y6tZgSjbmqamO4U20Ljj/dQMFruVjU=";
  pnpmDepsHash = "sha256-JeRolDKVf2EInZVAt/HpkurzgDcE592jF5stJ+qZY9U=";
}
