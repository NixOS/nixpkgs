{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "chopchop";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "michelin";
    repo = "ChopChop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qSBQdcS6d0tctSHRbkY4T7s6Zj7xI2abaPUvNKh1M2E=";
  };

  vendorHash = "sha256-UxWARWOFp8AYKEdiJwRZNwFrphgMTJSZjnvktTNOsgU=";

  meta = {
    description = "CLI to search for sensitive services/files/folders";
    homepage = "https://github.com/michelin/ChopChop";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
