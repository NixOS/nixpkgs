{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-explore";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "keisku";
    repo = "kubectl-explore";
    rev = "v${version}";
    hash = "sha256-OVPct3EvtchH9pmMulIddsiR9VFoCegx9+O7lkecoJc=";
  };

  vendorHash = "sha256-l6SANWkDQSuLbyixbO/Xr2oRG8HR/qquTT9b/IM+JVg=";
  doCheck = false;

  meta = with lib; {
    description = "A better kubectl explain with the fuzzy finder";
    homepage = "https://github.com/keisku/kubectl-explore";
    changelog = "https://github.com/keisku/kubectl-explore/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.koralowiec ];
  };
}
