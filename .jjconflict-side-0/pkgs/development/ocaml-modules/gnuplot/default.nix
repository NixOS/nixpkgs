{ lib, buildDunePackage, fetchFromGitHub, gnuplot, iso8601 }:

buildDunePackage rec {
  pname = "gnuplot";
  version = "0.7";

  useDune2 = true;

  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner  = "c-cube";
    repo   = "ocaml-${pname}";
    rev    = "v${version}";
    sha256 = "02pzi3lb57ysrdsba743s3vmnapjbxgq8ynlzpxbbs6cn1jj6ch9";
  };

  propagatedBuildInputs = [ gnuplot iso8601 ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Ocaml bindings to Gnuplot";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl21;
  };
}
