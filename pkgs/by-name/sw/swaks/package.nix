{ lib, stdenv, fetchurl, perl, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "swaks";
  version = "20240103.0";

  src = fetchurl {
    url = "https://www.jetmore.org/john/code/swaks/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-DlMbTRZAWIAucmaxT03BiXCZ0Jb5MIIN4vm16wjc2+g=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    mv swaks $out/bin/

    wrapProgram $out/bin/swaks --set PERL5LIB \
      "${with perlPackages; makePerlPath [
        NetSSLeay AuthenSASL NetDNS IOSocketINET6
      ]}"
  '';

  meta = with lib; {
    homepage = "http://www.jetmore.org/john/code/swaks/";
    description = "Featureful, flexible, scriptable, transaction-oriented SMTP test tool";
    mainProgram = "swaks";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };

}
