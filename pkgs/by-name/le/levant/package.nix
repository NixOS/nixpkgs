{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "levant";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "levant";
    rev = "v${version}";
    sha256 = "sha256-pinrBLzBMptqzMMiQmZob6B5rNNyQsaEkuECFFyTkrw=";
  };

  vendorHash = "sha256-z3QoDcp7l3XUNo4xvgd6iD1Nw6cly2CoxjRtbo+IKQ0=";

  # The tests try to connect to a Nomad cluster.
  doCheck = false;

  meta = with lib; {
    description = "Open source templating and deployment tool for HashiCorp Nomad jobs";
    mainProgram = "levant";
    homepage = "https://github.com/hashicorp/levant";
    license = licenses.mpl20;
    maintainers = with maintainers; [ max-niederman ];
  };
}
