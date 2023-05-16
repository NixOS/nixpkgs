{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "argo-rollouts";
<<<<<<< HEAD
  version = "1.5.1";
=======
  version = "1.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-rollouts";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ODcT7dc4xBHOKYTP2pUTq2z3GMUEpZ9OUKKxlbd+Vvk=";
  };

  vendorHash = "sha256-IxSLlRsOz/Xamguxm+7jy8qAAEZZFm/NHDIBjm5tnCs=";
=======
    sha256 = "sha256-MpiKdPjQRF1LzNxBvPucoeRkDfboJdStfQ6X+d2jiwk=";
  };

  vendorHash = "sha256-ZIFZCMyhpfKK/Irq2/MvkXuXX1jExDaSK/nXZgzCZgU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Disable tests since some test fail because of missing test data
  doCheck = false;

  subPackages = [ "cmd/rollouts-controller" "cmd/kubectl-argo-rollouts" ];

  meta = with lib; {
    description = "Kubernetes Progressive Delivery Controller";
    homepage = "https://github.com/argoproj/argo-rollouts/";
    license = licenses.asl20;
    maintainers = with maintainers; [ psibi ];
  };
}
