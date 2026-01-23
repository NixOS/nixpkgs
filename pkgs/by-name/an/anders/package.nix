{
  lib,
  fetchFromGitHub,
  ocamlPackages,
}:

ocamlPackages.buildDunePackage rec {
  pname = "anders";
  version = "1.1.1";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "groupoid";
    repo = "anders";
    tag = version;
    sha256 = "sha256-JUiZoo2rNLfgs94TlJqUNzul/7ODisCjSFAzhgSp1z4=";
  };

  strictDeps = true;

  nativeBuildInputs = [ ocamlPackages.menhir ];
  buildInputs = [ ocamlPackages.zarith ];

  meta = {
    description = "Modal Homotopy Type System";
    mainProgram = "anders";
    homepage = "https://homotopy.dev/";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.suhr ];
  };
}
