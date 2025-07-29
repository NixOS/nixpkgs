{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-explore";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "keisku";
    repo = "kubectl-explore";
    rev = "v${version}";
    hash = "sha256-D5K1jGLoEHQEacxNhxdxDs9A9ir7qs7y1pNuBU2r//Y=";
  };

  vendorHash = "sha256-vCL+gVf0BCqsdRU2xk1Xs3FYcKYB1z2wLpZ3TvYmJdc=";
  doCheck = false;

  meta = {
    description = "Better kubectl explain with the fuzzy finder";
    mainProgram = "kubectl-explore";
    homepage = "https://github.com/keisku/kubectl-explore";
    changelog = "https://github.com/keisku/kubectl-explore/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.koralowiec ];
  };
}
