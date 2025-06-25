{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "damon";
  version = "unstable-2021-10-06";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "damon";
    rev = "542c79aecc44b1d0500f9cb9b2e13f07db1e2f35";
    sha256 = "sha256-vg5PISNqk8N2nn7eABm+/7qzePDbKPkvovdZk2sZYsg=";
  };

  vendorHash = "sha256-/ZZxw6qEUJQUz3J0TxUYJECCcX276r74g0N2tV77+8I=";

  meta = with lib; {
    homepage = "https://github.com/hashicorp/damon";
    license = licenses.mpl20;
    description = "Terminal UI (TUI) for HashiCorp Nomad";
    teams = [ teams.iog ];
    mainProgram = "damon";
  };
}
