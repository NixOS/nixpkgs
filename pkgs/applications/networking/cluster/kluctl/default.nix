{ lib, stdenv, buildGoModule, fetchFromGitHub, testers, kluctl }:

buildGoModule rec {
  pname = "kluctl";
<<<<<<< HEAD
  version = "2.20.8";
=======
  version = "2.19.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kluctl";
    repo = "kluctl";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-F4vEHzN44+d0EtfJukEq5WVm8aLVWqmT5Xcpa/DBPng=";
  };

  vendorHash = "sha256-x5Zy8H7DzxU+uBCUL6edv8x2LwiIjXl5UrRUMDtUEk8=";
=======
    hash = "sha256-yp471eWrwnJiCAVwqnZzq1rN1Mt4d42ymVvsUtTyOsc=";
  };

  vendorHash = "sha256-Ws0Qaw2hk8alOF/K5Wd0ZcMGr6Q3JiQIo/kHOXiGvmg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X main.version=v${version}" ];

  # Depends on docker
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = kluctl;
    version = "v${version}";
  };

<<<<<<< HEAD
  postInstall = ''
    mv $out/bin/{cmd,kluctl}
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "The missing glue to put together large Kubernetes deployments";
    homepage = "https://kluctl.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir ];
  };
}
