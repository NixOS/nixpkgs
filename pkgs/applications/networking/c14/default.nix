{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "c14-cli";
  version = "0.3";

  goPackagePath = "github.com/online-net/c14-cli";

  src = fetchFromGitHub {
    owner = "online-net";
    repo = "c14-cli";
    rev = version;
    sha256 = "0b1piviy6vvdbak8y8bc24rk3c1fi67vv3352pmnzvrhsar2r5yf";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "C14 is designed for data archiving & long-term backups.";
    homepage = https://www.online.net/en/c14;
    license = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
