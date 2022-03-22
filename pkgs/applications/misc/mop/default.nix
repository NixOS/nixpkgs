{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "mop";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mop-tracker";
    repo = "mop";
    rev = "bc666ec165d08b43134f7ec0bf29083ad5466243";
    sha256 = "sha256-fX7G4M3gfv31Eb2HChTY4RfVF2U92000U4ZnFNML5X4=";
  };

  goPackagePath = "github.com/michaeldv/mop";
  goDeps = ./deps.nix;

  preConfigure = ''
    for i in *.go **/*.go; do
        substituteInPlace $i --replace michaeldv/termbox-go nsf/termbox-go
    done
    substituteInPlace Makefile --replace mop/cmd mop/mop
    mv cmd mop
  '';

  meta = with lib; {
    description = "Simple stock tracker implemented in go";
    homepage =  "https://github.com/mop-tracker/mop";
    license = licenses.mit;
  };
}
