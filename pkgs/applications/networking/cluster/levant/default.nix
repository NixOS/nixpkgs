{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "levant";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "levant";
    rev = "v${version}";
    sha256 = "sha256-UI8PVvTqk8D4S9kq3sgxrm8dkRokpgkLyTN6pzUXNV0=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-MzKttGfuIg0Pp/iz68EpXuk4I+tFozhIabKlsWuvJ48=";
=======
  vendorSha256 = "sha256-MzKttGfuIg0Pp/iz68EpXuk4I+tFozhIabKlsWuvJ48=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # The tests try to connect to a Nomad cluster.
  doCheck = false;

  meta = with lib; {
    description = "An open source templating and deployment tool for HashiCorp Nomad jobs";
    homepage = "https://github.com/hashicorp/levant";
    license = licenses.mpl20;
    maintainers = with maintainers; [ max-niederman ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
