{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "symfpu";
  version = "unstable-2019-05-17";

  src = fetchFromGitHub {
    owner  = "martin-cs";
    repo   = "symfpu";
    rev    = "8fbe139bf0071cbe0758d2f6690a546c69ff0053";
    sha256 = "1jf5lkn67q136ppfacw3lsry369v7mdr1rhidzjpbz18jfy9zl9q";
  };

  installPhase = ''
    mkdir -p $out/symfpu
    cp -r * $out/symfpu/
  '';

  meta = with lib; {
    description = "A (concrete or symbolic) implementation of IEEE-754 / SMT-LIB floating-point";
    homepage    = "https://github.com/martin-cs/symfpu";
    license     = licenses.gpl3Only;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ shadaj ];
  };
}
