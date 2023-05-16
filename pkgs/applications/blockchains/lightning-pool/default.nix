{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "lightning-pool";
<<<<<<< HEAD
  version = "0.6.4-beta";
=======
  version = "0.5.3-alpha";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "pool";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-lSc/zOZ5VpmaZ7jrlGvSaczrgOtAMS9tDUxcMoFdBmQ=";
  };

  vendorHash = "sha256-DD27zUW524qe9yLaVPEzw/c4sSzlH89HMw0PdtNYEhg=";

  subPackages = [ "cmd/pool" "cmd/poold" ];

  ldflags = [ "-s" "-w" ];

=======
    sha256 = "1nc3hksk9qcxrsyqpz9vcfc8x093rc8yx8ppfk177j9fhdnn8bk7";
  };

  vendorSha256 = "09yxaa74814l1rp0arqhqpplr2j0p8dj81zqcbxlwp5ckjv9r2za";

  subPackages = [ "cmd/pool" "cmd/poold" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Lightning Pool Client";
    homepage = "https://github.com/lightninglabs/pool";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
