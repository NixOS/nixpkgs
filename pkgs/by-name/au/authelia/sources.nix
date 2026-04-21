{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.19";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-wMOurdgdjykFekn0Pej3meM6WSzq9tJ+kZV9sVDvRwM=";
  };
  vendorHash = "sha256-ZDsLRMip2B8PPZu8VxW+91FVvwC2rXzohhAZFifT26g=";
  pnpmDepsHash = "sha256-HMrC5V+Ak2dF1uPtbh8kgFc8kZI2FPMmZHJciWRYx9w=";
}
