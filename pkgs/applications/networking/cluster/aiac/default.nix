{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aiac";
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "2.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  excludedPackages = [".ci"];

  src = fetchFromGitHub {
    owner = "gofireflyio";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-BCcoMftnvfAqmabnSz/oRAlJg95KJ236mduxV2DfRG4=";
=======
    hash = "sha256-C9eQdN8S8Qe0x+Uly69nbYNXDKpi1uZ6qNBetn2P4Gk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-Uqr9wH7hCLdZEu6DXddgB7NuLtqcjUbOPJ2YX+9ehKM=";
  ldflags = [ "-s" "-w" "-X github.com/gofireflyio/aiac/v3/libaiac.Version=v${version}" ];

  meta = with lib; {
    description = ''Artificial Intelligence Infrastructure-as-Code Generator.'';
    homepage = "https://github.com/gofireflyio/aiac/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
