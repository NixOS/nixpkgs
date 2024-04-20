{ lib, buildGoModule, fetchFromGitHub, }:
buildGoModule rec {
  pname = "prometheus-github-exporter";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "githubexporter";
    repo = "github-exporter";
    rev = "${version}";
    hash = "sha256-sHmugAVi9wGh0sR6tPDXp0FlRG96WY4/MXMHv2TC50E=";
  };

  vendorHash = "sha256-ZO9Dq9tuNP+262eEwBzptBMNtGIxkc7y4MCwMnRSTnE=";

  meta = with lib; {
    homepage = "https://github.com/githubexporter/github-exporter";
    description = "Github Exporter for Prometheus";
    license = licenses.mit;
    mainProgram = "github-exporter";
    maintainers = with maintainers; [ swendel ];
  };
}
