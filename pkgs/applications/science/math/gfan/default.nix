{stdenv, fetchurl, gmp, mpir, cddlib}:
stdenv.mkDerivation rec {
  pname = "gfan";
  version = "0.6.2";

  src = fetchurl {
    url = "http://home.math.au.dk/jensen/software/gfan/gfan${version}.tar.gz";
    sha256 = "02pihqb1lb76a0xbfwjzs1cd6ay3ldfxsm8dvsbl6qs3vkjxax56";
  };

  patches = [
    ./gfan-0.6.2-cddlib-prefix.patch
  ];

  postPatch = stdenv.lib.optionalString stdenv.cc.isClang ''
    substituteInPlace Makefile --replace "-fno-guess-branch-probability" ""
  '';

  buildFlags = [ "CC=cc" "CXX=c++" ];
  installFlags = [ ''PREFIX=$(out)'' ];
  buildInputs = [ gmp mpir cddlib ];

  meta = {
    inherit version;
    description = ''A software package for computing Gröbner fans and tropical varieties'';
    license = stdenv.lib.licenses.gpl2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
    homepage = "http://home.math.au.dk/jensen/software/gfan/gfan.html";
  };
}
