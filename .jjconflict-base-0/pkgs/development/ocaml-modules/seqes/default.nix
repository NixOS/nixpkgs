{
  lib,
  fetchurl,
  buildDunePackage,
  qcheck,
  qcheck-alcotest,
  alcotest,
}:

buildDunePackage rec {
  pname = "seqes";
  version = "0.2";
  src = fetchurl {
    url = "https://gitlab.com/nomadic-labs/seqes/-/archive/${version}/seqes-${version}.tar.gz";
    sha256 = "sha256-IxLA0jaIPdX9Zn/GL8UHDJYjA1UBW6leGbZmp64YMjI=";
  };

  minimalOCamlVersion = "4.14";

  doCheck = true;
  checkInputs = [
    qcheck
    qcheck-alcotest
    alcotest
  ];

  meta = with lib; {
    description = "Variations of the Seq module with monads folded into the type";
    homepage = "https://gitlab.com/nomadic-labs/seqes";
    license = licenses.lgpl2; # Same as OCaml
    maintainers = [ maintainers.ulrikstrid ];
  };
}
