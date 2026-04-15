{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.18";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-IROdncF3TC1X9000jw0RGtrcFrzqRpG7g2QuLGQ/Q4k=";
  };
  vendorHash = "sha256-ZDsLRMip2B8PPZu8VxW+91FVvwC2rXzohhAZFifT26g=";
  pnpmDepsHash = "sha256-ki/jXNT9dIno1UIcDgBcsLdiKcaiw/dwnff3t9xv07o=";
}
