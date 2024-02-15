{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubecolor";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zXglsfPsJi9DVxlRPniSBsdF1xEMYqqGr46ThpQj3gQ=";
  };

  vendorHash = "sha256-uf7nBnS1wmbz4xcVA5qF82QMPsLdSucje1NNaPyheCw=";

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  meta = with lib; {
    description = "Colorizes kubectl output";
    homepage = "https://github.com/kubecolor/kubecolor";
    changelog = "https://github.com/kubecolor/kubecolor/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ivankovnatsky SuperSandro2000 applejag ];
  };
}
