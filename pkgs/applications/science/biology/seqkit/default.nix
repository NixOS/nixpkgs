{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "seqkit";
<<<<<<< HEAD
  version = "2.5.1";
=======
  version = "2.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "seqkit";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-aS8aTh8Lszob9It89shhKyqxCDjFs7zxE3VhMCHYaGM=";
  };

  vendorHash = "sha256-54kb9Na76+CgW61SnXu7EfO0InH/rjliNRcH2M/gxII=";
=======
    sha256 = "sha256-v2Z94UDuXnT7eVFX+uLSxXR34eIBzRm1bHwD7gO9SVA=";
  };

  vendorHash = "sha256-dDMSwZnTWC60zvPDvUT+9T/mUUrhW0Itn87XO/+Ef2Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "cross-platform and ultrafast toolkit for FASTA/Q file manipulation";
    homepage = "https://github.com/shenwei356/seqkit";
    license = licenses.mit;
    maintainers = with maintainers; [ bzizou ];
  };
}
