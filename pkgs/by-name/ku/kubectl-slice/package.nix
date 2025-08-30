{
  lib,
  buildGo124Module,
  fetchFromGitHub,
}:

buildGo124Module rec {
  pname = "kubectl-slice";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "patrickdappollonio";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-C9YxMP9MCKJXh3wQ1JoilpzI3nIH3LnsTeVPMzri5h8=";
  };

  vendorHash = "sha256-Lly8gGLkpBAT+h1TJNkt39b5CCrn7xuVqrOjl7RWX7w=";

  meta = {
    description = "Split multiple Kubernetes files into smaller files with ease.";
    mainProgram = "kubectl-slice";
    homepage = "https://github.com/patrickdappollonio/kubectl-slice";
    changelog = "https://github.com/patrickdappollonio/kubectl-slice/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mikansoro ];
  };
}
