{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hashi-up";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "jsiebens";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PdZ8X2pJ5TfT0bJ4/P/XbMTv+yyL5/1AxIFHnL/qNcg=";
  };

  vendorHash = "sha256-dircE3WlDPsPnF+0wT5RG/c4hC8qPs8NaSGM5wpvVlM=";

  meta = with lib; {
    description = "A lightweight utility to install HashiCorp Consul, Nomad, or Vault on any remote Linux host";
    homepage = "https://github.com/jsiebens/hashi-up";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
