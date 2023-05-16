{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mop";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mop-tracker";
    repo = "mop";
    rev = "v${version}";
    sha256 = "sha256-oe8RG8E7xcp3ZqdDXYvpOVF3AfeSBFMherHD1YYFE/M=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-kLQH7mMmBSsS9av+KnnEuBwiH6hzBOSozrn+1X+8774=";
=======
  vendorSha256 = "sha256-kLQH7mMmBSsS9av+KnnEuBwiH6hzBOSozrn+1X+8774=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preConfigure = ''
    for i in *.go **/*.go; do
        substituteInPlace $i --replace michaeldv/termbox-go nsf/termbox-go
    done
    substituteInPlace Makefile --replace mop/cmd mop/mop
    mv cmd mop
  '';

  meta = with lib; {
    description = "Simple stock tracker implemented in go";
    homepage = "https://github.com/mop-tracker/mop";
    license = licenses.mit;
  };
}
