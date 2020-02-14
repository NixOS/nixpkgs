{ stdenv, fetchurl }:

let
  version = "1.1.1";
in
stdenv.mkDerivation {
  pname = "teseq";
  inherit version;

  src = fetchurl {
    url = "mirror://gnu/teseq/teseq-${version}.tar.gz";
    sha256 = "08ln005qciy7f3jhv980kfhhfmh155naq59r5ah9crz1q4mx5yrj";
  };

  meta = {
    homepage = https://www.gnu.org/software/teseq/;
    description = "Escape sequence illuminator";
    license = stdenv.lib.licenses.gpl3;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.vaibhavsagar ];
  };
}
