{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "ssh-chat";
  version = "1.10";

  goPackagePath = "github.com/shazow/ssh-chat";

  src = fetchFromGitHub {
    owner = "shazow";
    repo = "ssh-chat";
    rev = "v${version}";
    sha256 = "e4COAyheY+mE5zltR1Ms2OJ3I8iG/N1CZ6D7I9PDW5U=";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Chat over SSH";
    homepage = "https://github.com/shazow/ssh-chat";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r ];
  };
}
