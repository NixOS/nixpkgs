{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubecm";
<<<<<<< HEAD
  version = "0.25.0";
=======
  version = "0.23.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sunny0826";
    repo = "kubecm";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-8Y8JChZxjbN/nOw2tzDfJvYSMAtAadf6QMsDFK4IIOg=";
  };

  vendorHash = "sha256-HjMgXEDX9pDpK+1Hm0xI0wYRfpj7K6xkZJXCUBqbE3Y=";
=======
    hash = "sha256-BywtQ6YVGPz5A0GE2q0zRoBZNU6HZgVbr6H0OMR05wM=";
  };

  vendorHash = "sha256-WZxjv4v2nfJjbzFfaDh2kE7ZBREB+Q8BmHhUrAiDd7g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ldflags = [ "-s" "-w" "-X github.com/sunny0826/kubecm/version.Version=${version}"];

  doCheck = false;

  meta = with lib; {
    description = "Manage your kubeconfig more easily";
    homepage = "https://github.com/sunny0826/kubecm/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
