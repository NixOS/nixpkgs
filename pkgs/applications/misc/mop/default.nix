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

  vendorHash = "sha256-kLQH7mMmBSsS9av+KnnEuBwiH6hzBOSozrn+1X+8774=";

  preConfigure = ''
    for i in *.go **/*.go; do
        substituteInPlace $i --replace-fail michaeldv/termbox-go nsf/termbox-go
    done
    substituteInPlace Makefile --replace-fail mop/cmd mop/mop
    mv cmd mop
  '';

  meta = with lib; {
    description = "Simple stock tracker implemented in go";
    homepage = "https://github.com/mop-tracker/mop";
    license = licenses.mit;
    mainProgram = "mop";
  };
}
