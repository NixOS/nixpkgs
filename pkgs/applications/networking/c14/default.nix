{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "c14-cli-2017-20-05";
  goPackagePath = "github.com/online-net/c14-cli";
  subPackages = [ "cmd/c14" ];

  src = fetchFromGitHub {
    owner = "online-net";
    repo = "c14-cli";
    rev = "97f437ef5133f73edd551c883db3076c76cb1f6b";
    sha256 = "1b44bh0zhh6rhw4d3nprnnxhjgaskl9kzp2cvwwyli5svhjxrfdj";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "C14 is designed for data archiving & long-term backups.";
    homepage = "https://www.online.net/en/c14";
    license = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
