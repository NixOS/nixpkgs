{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "juju";
  version = "2.9.25";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "juju-${version}";
    sha256 = "sha256-h4w12dmGEviV2N0BWXQKt1eUVxdbgwRKLQghnd6bLFI=";
  };

  vendorSha256 = "sha256-AATK4tDg2eW8Bt8gU88tIk6I+qp5ZeUtXzD74/59c7w=";

  # Disable tests because it attempts to use a mongodb instance
  doCheck = false;

  meta = with lib; {
    description = "Open source modelling tool for operating software in the cloud";
    homepage = "https://juju.is";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
  };
}
