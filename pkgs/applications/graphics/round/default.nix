{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "round";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "mingrammer";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vP2q0inU5zNJ/eiAqEzwHSqril8hTtpbpNBiAkeWeSU=";
  };

  vendorHash = null;
=======
    sha256 = "09brjr3h4qnhlidxlki1by5anahxy16ai078zm4k7ryl579amzdw";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  meta = with lib; {
    description = "Round image corners from CLI";
    homepage    = "https://github.com/mingrammer/round";
    license     = licenses.mit;
    maintainers =  with maintainers; [ addict3d ];
  };
}
