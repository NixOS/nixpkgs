{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeconform";
<<<<<<< HEAD
  version = "0.6.3";
=======
  version = "0.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "yannh";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Tu1hAWAqnTGq9NL0kjG2VGzSKDh55HyAoa0nhsJdNLw=";
=======
    sha256 = "sha256-98wSFntt5ERbQ7URMlRz3iMTuL1beuX2nXbdWe+6Quw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  meta = with lib; {
    description = "A FAST Kubernetes manifests validator, with support for Custom Resources!";
    homepage    = "https://github.com/yannh/kubeconform/";
    license     = licenses.asl20;
    maintainers = [ maintainers.j4m3s ];
  };
}
