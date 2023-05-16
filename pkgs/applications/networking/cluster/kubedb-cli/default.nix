{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubedb-cli";
<<<<<<< HEAD
  version = "0.35.0";
=======
  version = "0.33.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kubedb";
    repo = "cli";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-keYCF/Jte3sgJi4fnVO1ZDAsYyqXlHzX91tyS5oVCW4=";
=======
    sha256 = "sha256-J5eEyLoeYC4JhreuN+ymeVMfnyf9ADL08FpnpmRy1vI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  # Don't compile the documentation stuff
  subPackages = [ "cmd/kubectl-dba" ];

  meta = with lib; {
    description = "kubectl plugin for KubeDB by AppsCode.";
    homepage    = "https://github.com/kubedb/cli";
    license     = licenses.unfree;
    maintainers = [ maintainers.starcraft66 ];
  };
}
