{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-loop";
<<<<<<< HEAD
  version = "0.24.1-beta";
=======
  version = "0.23.0-beta";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-gPWiKSwXS1eSuHss+hkiqqxqonGYSGmSh3/jL+NlqEg=";
  };

  vendorHash = "sha256-6bRg6is1g/eRCr82tHMXTWVFv2S0d2h/J3w1gpentjo=";

  subPackages = [ "cmd/loop" "cmd/loopd" ];

  ldflags = [ "-s" "-w" ];

=======
    sha256 = "sha256-nYDu451BS5gV4pbV9Pp+S7oKsLGzgVu1a9Df7651e4c=";
  };

  vendorSha256 = "sha256-6bRg6is1g/eRCr82tHMXTWVFv2S0d2h/J3w1gpentjo=";

  subPackages = [ "cmd/loop" "cmd/loopd" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
