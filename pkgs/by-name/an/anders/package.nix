{
  lib,
  fetchFromGitHub,
  ocamlPackages,
}:

ocamlPackages.buildDunePackage rec {
  pname = "anders";
  version = "5.1.0";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "groupoid";
    repo = "anders";
    tag = version;
    sha256 = "sha256-SWM0Oijm5ppFUE5O+s9feSNKULLstrAyI/xns1SE8X8=";
  };

  strictDeps = true;

  nativeBuildInputs = [ ocamlPackages.menhir ];
  buildInputs = [ ocamlPackages.zarith ];

  meta = {
    description = "Modal Homotopy Type System";
    mainProgram = "anders";
    homepage = "https://homotopy.dev/";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
