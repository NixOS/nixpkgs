{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-licence-detector";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "go-licence-detector";
    rev = "v${version}";
    hash = "sha256-Mo4eBBP9UueLEMVnxndatizDaxVyZuHACvFoV38dRVI=";
  };

  vendorHash = "sha256-quFa2gBPsyRMOBde+KsIF8NCHYSF+X9skvIWnpm2Nss=";

  meta = {
    description = "Detect licences in Go projects and generate documentation";
    homepage = "https://github.com/elastic/go-licence-detector";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
