{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "ssh-chat";
  version = "1.9";

  goPackagePath = "github.com/shazow/ssh-chat";

  src = fetchFromGitHub {
    owner = "shazow";
    repo = "ssh-chat";
    rev = "v${version}";
    sha256 = "04yszan6a7x9498s80xymf7wd10530yjrxcdw4czbplyhjdigxlg";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Chat over SSH";
    homepage = "https://github.com/shazow/ssh-chat";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
  };
}
