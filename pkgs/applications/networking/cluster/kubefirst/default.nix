{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubefirst";
<<<<<<< HEAD
  version = "2.2.17";
=======
  version = "2.0.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kubefirst";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cqKnoGRW+IquuZ7wvCRipRJ6mO18w/yhf5nS094vs7c=";
  };

  vendorHash = "sha256-0J27JSewc0DCcc3xvl2DBZE/b0qKuozuP7tFdbrRX7I=";
=======
    hash = "sha256-JGseXRUehRuH1kuTfmkAJcfRN3vM0zN7K8pnOfJ0LAs=";
  };

  vendorHash = "sha256-Sc6HXJXkZ9vW6sxEKCTo6LDHeOGLTz0oN9JH11iUA/k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X github.com/kubefirst/runtime/configs.K1Version=v${version}"];

  doCheck = false;

  meta = with lib; {
    description = "The Kubefirst CLI creates instant GitOps platforms that integrate some of the best tools in cloud native from scratch.";
    homepage = "https://github.com/kubefirst/kubefirst/";
    license = licenses.mit;
    maintainers = with maintainers; [ qjoly ];
  };
}
