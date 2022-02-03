{ lib, fetchFromGitHub, ocamlPackages }:

ocamlPackages.buildDunePackage rec {
  pname = "anders";
  version = "1.1.1";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "groupoid";
    repo = "anders";
    rev = "${version}";
    sha256 = "sha256-JUiZoo2rNLfgs94TlJqUNzul/7ODisCjSFAzhgSp1z4=";
  };

  buildInputs = with ocamlPackages; [ zarith menhir ];

  meta = with lib; {
    description = "Modal Homotopy Type System";
    homepage = "https://homotopy.dev/";
    license = licenses.isc;
    maintainers = [ maintainers.suhr ];
  };
}
