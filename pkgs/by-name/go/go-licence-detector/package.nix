{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-licence-detector";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "go-licence-detector";
    rev = "v${version}";
    hash = "sha256-z2fJsDnDhD/0fF1QEQIKB398TqAsug1Ye5LbGpJWyfE=";
  };

  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail "go 1.24.5" "go 1.24"
  '';

  vendorHash = "sha256-quFa2gBPsyRMOBde+KsIF8NCHYSF+X9skvIWnpm2Nss=";

  meta = with lib; {
    description = "Detect licences in Go projects and generate documentation";
    homepage = "https://github.com/elastic/go-licence-detector";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
