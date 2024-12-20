{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "chopchop";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "michelin";
    repo = "ChopChop";
    rev = "v${version}";
    hash = "sha256-qSBQdcS6d0tctSHRbkY4T7s6Zj7xI2abaPUvNKh1M2E=";
  };

  vendorHash = "sha256-UxWARWOFp8AYKEdiJwRZNwFrphgMTJSZjnvktTNOsgU=";

  meta = with lib; {
    description = "CLI to search for sensitive services/files/folders";
    homepage = "https://github.com/michelin/ChopChop";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
