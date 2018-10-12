{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "stern-${version}";
  version = "1.8.0";

  goPackagePath = "github.com/wercker/stern";

  src = fetchFromGitHub {
    owner = "wercker";
    repo = "stern";
    rev = "${version}";
    sha256 = "14ccgb41ca2gym7wab0q02ap8g94nhfaihs41qky4wnsfv6j1zc8";
  };

  goDeps = ./deps.nix;

   meta = with lib; {
      description      = "Multi pod and container log tailing for Kubernetes";
      homepage         = "https://github.com/wercker/stern";
      license          = licenses.asl20;
      maintainers      = with maintainers; [ mbode ];
      platforms        = platforms.unix;
    };
}
