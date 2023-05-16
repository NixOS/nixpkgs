{ lib
<<<<<<< HEAD
, buildGoModule
, fetchFromGitHub
=======
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "lndhub-go";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "lndhub.go";
<<<<<<< HEAD
    rev = version;
=======
    rev = "${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sha256 = "sha256-m+Sc/rsYIbvd1oOqG4OT+wPtSxlgFq8m03n28eZIWJU=";
  };

  vendorHash = "sha256-a4yVuEfhLNM8IEYnafWf///SNLqQL5XZfGgJ5AZLx3c=";

  doCheck = false; # tests require networking

  meta = with lib; {
    description = "Accounting wrapper for the Lightning Network";
    homepage = "https://github.com/getAlby/lndhub.go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
