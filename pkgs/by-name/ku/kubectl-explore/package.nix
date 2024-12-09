{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-explore";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "keisku";
    repo = "kubectl-explore";
    rev = "v${version}";
    hash = "sha256-RCLOqe4Ptac2YVDjWYG5H5geUMUsmh6klQfk92XvjI4=";
  };

  vendorHash = "sha256-7KTs41zPf07FdUibsq57vJ2fkqOaVeBR6iSTJm5Fth0=";
  doCheck = false;

  meta = with lib; {
    description = "Better kubectl explain with the fuzzy finder";
    mainProgram = "kubectl-explore";
    homepage = "https://github.com/keisku/kubectl-explore";
    changelog = "https://github.com/keisku/kubectl-explore/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.koralowiec ];
  };
}
