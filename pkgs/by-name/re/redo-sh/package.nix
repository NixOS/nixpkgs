{ lib, stdenv, fetchurl, makeWrapper, coreutils }:

stdenv.mkDerivation {
  version = "4.0.4";
  pname = "redo-sh";

  src = fetchurl {
    url = "http://news.dieweltistgarnichtso.net/bin/archives/redo-sh.tar.gz";
    sha256 = "0d3hz3vy5qmjr9r4f8a5cx9hikpzs8h8f0fsl3dpbialf4wck24g";
  };

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = ".";
  installPhase = ''
    mkdir -p "$out/share"
    mv man "$out/share"
    mv bin "$out"
    for p in $out/bin/*; do
      wrapProgram "$p" --prefix PATH : "$out/bin:${coreutils}/bin"
    done
  '';

  meta = with lib; {
    description = "Redo implementation in Bourne Shell";
    homepage = "http://news.dieweltistgarnichtso.net/bin/redo-sh.html";
    license  = licenses.agpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
