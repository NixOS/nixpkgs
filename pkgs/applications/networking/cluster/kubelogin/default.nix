{ lib, fetchFromGitHub, buildGoModule, go }:

buildGoModule rec {
  pname = "kubelogin";
<<<<<<< HEAD
  version = "0.0.31";
=======
  version = "0.0.29";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-yIRiIZKq+Q10Uo/9qEToeMHMipA5rApkxIRr/IJ0yfY=";
  };

  vendorHash = "sha256-XHSVLATWKklg1jWL4Lnaey7hCkYHAk/cNyUgQZ6WIq0=";
=======
    sha256 = "sha256-B6p+quzFPx2KHVqUvJly2x+F9pHBWaUxuSdhG36V/5U=";
  };

  vendorHash = "sha256-H8hfphAcz/Lc1JLxejodV4YQ9IPyPgVeDXdPT9AYpmk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-X main.version=${version}"
    "-X main.goVersion=${lib.getVersion go}"
  ];

  meta = with lib; {
    description = "A Kubernetes credential plugin implementing Azure authentication";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
  };
}
