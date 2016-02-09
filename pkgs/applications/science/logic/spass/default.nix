{ stdenv, fetchurl }:

let
  baseVersion="3";
  minorVersion="7";
in

stdenv.mkDerivation rec {
  name = "spass-${version}";
  version = "${baseVersion}.${minorVersion}";

  src = fetchurl {
    url = "http://www.spass-prover.org/download/sources/spass${baseVersion}${minorVersion}.tgz";
    sha256 = "1k5a98kr3vzga54zs7slwwaaf6v6agk1yfcayd8bl55q15g7xihk";
  };

  meta = with stdenv.lib; {
    description = "An automated theorem preover for FOL";
    maintainers = with maintainers;
    [
      raskin
    ];
    platforms = platforms.linux;
    license = licenses.bsd2;
    downloadPage = "http://www.spass-prover.org/download/index.html";
  };
}
