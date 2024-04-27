{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-explore";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "keisku";
    repo = "kubectl-explore";
    rev = "v${version}";
    hash = "sha256-3Gb8lgfes3QIIAdJnC/NlCC3mfzIInQb1rG+mJNXAUk=";
  };

  vendorHash = "sha256-xNB+qC36DcD7oUWk242QcIKNfTmjuK5xbyJEztdhcJM=";
  doCheck = false;

  meta = with lib; {
    description = "A better kubectl explain with the fuzzy finder";
    mainProgram = "kubectl-explore";
    homepage = "https://github.com/keisku/kubectl-explore";
    changelog = "https://github.com/keisku/kubectl-explore/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.koralowiec ];
  };
}
