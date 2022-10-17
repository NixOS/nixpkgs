{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-tree";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tE3ujknd7GDjTPIzZaL1Ynm6F9tJI/R1u2l0nCttjrI=";
  };

  vendorSha256 = "sha256-EQEsOJ/IZoR+9CjfFtQmBGeUXgmtACDvvpKCgnep+go=";

  meta = with lib; {
    description = "kubectl plugin to browse Kubernetes object hierarchies as a tree";
    homepage = "https://github.com/ahmetb/kubectl-tree";
    changelog = "https://github.com/ahmetb/kubectl-tree/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
