{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-tree";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-J4/fiTECcTE0N2E+MPrQKE9Msvvm8DLdvLbnDUnUo74=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-iblEfpYOvTjd3YXQ3Mmj5XckivHoXf4336H+F7NEfBA=";
=======
  vendorSha256 = "sha256-iblEfpYOvTjd3YXQ3Mmj5XckivHoXf4336H+F7NEfBA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "kubectl plugin to browse Kubernetes object hierarchies as a tree";
    homepage = "https://github.com/ahmetb/kubectl-tree";
    changelog = "https://github.com/ahmetb/kubectl-tree/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
