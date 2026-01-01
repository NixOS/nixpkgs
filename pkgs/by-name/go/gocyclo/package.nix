{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gocyclo";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "fzipp";
    repo = "gocyclo";
    rev = "v${version}";
    sha256 = "sha256-1IwtGUqshpLDyxH5NNkGUads1TKLs48eslNnFylGUPA=";
  };

  vendorHash = null;

<<<<<<< HEAD
  meta = {
    description = "Calculate cyclomatic complexities of functions in Go source code";
    mainProgram = "gocyclo";
    homepage = "https://github.com/fzipp/gocyclo";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kalbasit ];
=======
  meta = with lib; {
    description = "Calculate cyclomatic complexities of functions in Go source code";
    mainProgram = "gocyclo";
    homepage = "https://github.com/fzipp/gocyclo";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
