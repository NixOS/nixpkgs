{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "kepubify";
  version = "2.3.3";


  goPackagePath = "github.com/geek1011/kepubify";

  src = fetchFromGitHub {
    owner = "geek1011";
    repo = "kepubify";
    rev = "v${version}";
    sha256 = "1k8ips0dkbg607v81vjw3q86h3ls7mrpx62nhw6wsmix3cssms7y";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Converts epubs to kepubs";
    homepage = https://pgaskin.net/kepubify/;
    license = licenses.mit;
    maintainers = with maintainers; [ jacobdillon ];
  };
}
