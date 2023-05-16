{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "distribution";
<<<<<<< HEAD
  version = "2.8.2";
=======
  version = "2.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  rev = "v${version}";

  goPackagePath = "github.com/docker/distribution";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "distribution";
    inherit rev;
<<<<<<< HEAD
    sha256 = "sha256-aBAUyM+MtRZAA6Jxu4cFyRIo5OU+7IdLKdQqgm0AFPI=";
=======
    sha256 = "sha256-M8XVeIvD7LtWa9l+6ovwWu5IwFGYt0xDfcIwcU/KH/E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "The Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers = [ maintainers.globin ];
    platforms = platforms.unix;
  };
}
