{ IOKit
, buildGoModule
, fetchFromGitHub
, fetchpatch
, lib
, stdenv
}:

buildGoModule rec {
  pname = "avalanchego";
<<<<<<< HEAD
  version = "1.10.9";
=======
  version = "1.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ofIpTDlD8ztC5vR975GhH/yYb4LqVs17kdfbU2UN6gg=";
  };

  vendorHash = "sha256-EjdlIfY5he1P1JMJNwPNHFSwhlczGZb2ygvxviggesM=";
=======
    hash = "sha256-OQh8xub/4DHZk4sGIJldyoXGR/TQ9F0reERk2lpjYi8=";
  };

  vendorHash = "sha256-etvCtNCW6tuzKZEEx2RODzMx0W9hGoXNS2jWGJO+Pc0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # go mod vendor has a bug, see: https://github.com/golang/go/issues/57529
  proxyVendor = true;

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  subPackages = [ "main" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ava-labs/avalanchego/version.GitCommit=${version}"
  ];

  postInstall = ''
    mv $out/bin/{main,${pname}}
  '';

  meta = with lib; {
    description = "Go implementation of an Avalanche node";
    homepage = "https://github.com/ava-labs/avalanchego";
    changelog = "https://github.com/ava-labs/avalanchego/releases/tag/v${version}";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ urandom qjoly ];
=======
    maintainers = with maintainers; [ urandom ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
