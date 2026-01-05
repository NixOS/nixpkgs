{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "muparserx";
  version = "4.0.12";

  src = fetchFromGitHub {
    owner = "beltoforion";
    repo = "muparserx";
    rev = "v${version}";
    sha256 = "sha256-rekPXmncNdVX6LvPQP1M2Pzs3pyiCCcLPLnPFiyWJ4s=";
  };

  nativeBuildInputs = [ cmake ];

  patches = [
    # must be applied in order

    # cmake min required 2.8.12 -> 3.3
    (fetchpatch {
      url = "https://github.com/beltoforion/muparserx/commit/d671af0882d4ba09a4bba810877b796f1877d41e.patch?full_index=1";
      hash = "sha256-4pJrPTMVpTLZWu+PpTtgmtzryObw6vY/kjgsrPDqljw=";
    })

    # cmake min required 3.3 -> 3.17
    (fetchpatch {
      url = "https://github.com/beltoforion/muparserx/commit/c605872591d542e1630e3fcc4b292d8a0702acd2.patch?full_index=1";
      hash = "sha256-CZPh/+vBhuUXGGEE1fPQiaojpInWhGmFk1HG9pGuAPw=";
    })
  ];

  doCheck = true;
  checkPhase = ''
    echo "***Muparserx self-test***"
    echo "quit" | ./example > test_result.log
    cat test_result.log
    if grep -Fqi "failed" test_result.log; then
      echo ">=1 muparserx tests failed"
      exit 1
    else
      echo -e "\nmuparserx tests succeeded"
    fi
  '';

  meta = with lib; {
    description = "C++ Library for Parsing Expressions with Strings, Complex Numbers, Vectors, Matrices and more";
    homepage = "https://beltoforion.de/en/muparserx/";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
