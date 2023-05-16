{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pluto";
<<<<<<< HEAD
  version = "5.18.4";
=======
  version = "5.16.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-/8ZJXy5FErLnnXpED0UL+xqOo4QZtmR1hpcSpVsE8mw=";
  };

  vendorHash = "sha256-ysMRE/OwMf4rBnlkpkW9K8ZHEEbHpQ02RXNwLLSr0nY=";
=======
    sha256 = "sha256-UCq+aMUffvDWmPtSSc/PNbrak1LGWQe8Oe340O5q6LM=";
  };

  vendorHash = "sha256-0VFCZ+U0W21tF35148Valpc7fDXkC9dPpz1O0+4D30U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-w" "-s"
    "-X main.version=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/FairwindsOps/pluto";
    description = "Find deprecated Kubernetes apiVersions";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ peterromfeldhk kashw2 ];
=======
    maintainers = with maintainers; [ peterromfeldhk ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
