{ lib
, stdenv
, fetchurl
, gsl
, mpfr
, perl
, python3
}:

stdenv.mkDerivation rec {
  pname = "ViennaRNA";
  version = "2.4.18";

  src = fetchurl {
    url = "https://www.tbi.univie.ac.at/RNA/download/sourcecode/2_4_x/${pname}-${version}.tar.gz";
    sha256 = "17b0mcfkms0gn1a3faa4cakig65k9nk282x6mdh1mmjwbqzp5akw";
  };

  buildInputs = [
    gsl
    mpfr
    perl
    python3
  ];

  configureFlags = [
    "--with-cluster"
    "--with-kinwalker"
  ];

  meta = with lib; {
    description = "Prediction and comparison of RNA secondary structures";
    homepage = "https://www.tbi.univie.ac.at/RNA/";
    license = licenses.unfree;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.unix;
    # Perl bindings fail on aarch64-darwin with "Undefined symbols for architecture arm64"
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
