{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation {
  pname = "lkproof";
  version = "3.1";

  src = fetchurl {
    url = "https://mirror.ctan.org/macros/latex/contrib/lkproof.zip";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = "
    mkdir -p $out/share/texmf-nix/tex/generic/lkproof
    cp -prd *.sty $out/share/texmf-nix/tex/generic/lkproof
  ";

  meta = with lib; {
    platforms = platforms.unix;
    license = licenses.gpl1Plus;
  };
}
