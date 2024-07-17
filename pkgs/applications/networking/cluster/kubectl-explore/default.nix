{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubectl-explore";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "keisku";
    repo = "kubectl-explore";
    rev = "v${version}";
    hash = "sha256-jPif9SjHVKB346XkPCiIYpTc/xWRda9jjXefK/Nbyz0=";
  };

  vendorHash = "sha256-8kq6ODLf/y23zHsemNtjpM+R8OMKE4DDnK2TGHvunUE=";
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
