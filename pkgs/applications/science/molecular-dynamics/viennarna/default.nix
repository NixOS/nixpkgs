{ stdenv
, fetchurl
, gsl
, mpfr
, perl
, python3
}:

stdenv.mkDerivation rec {
  pname = "ViennaRNA";
  version = "2.4.17";

  src = fetchurl {
    url = "https://www.tbi.univie.ac.at/RNA/download/sourcecode/2_4_x/${pname}-${version}.tar.gz";
    sha256 = "08f1h2a8fn1s2zwf1244smiydhgwxgcnzy6irpdlmpvwygv0irmi";
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

  meta = with stdenv.lib; {
    description = "Prediction and comparison of RNA secondary structures";
    homepage = "https://www.tbi.univie.ac.at/RNA/";
    license = licenses.unfree;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.unix;
  };
}
