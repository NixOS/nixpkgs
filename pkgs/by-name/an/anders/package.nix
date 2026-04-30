{
  lib,
  fetchFromGitHub,
  ocamlPackages,
}:

ocamlPackages.buildDunePackage rec {
  pname = "anders";
  version = "5.0.0";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "groupoid";
    repo = "anders";
    tag = version;
    sha256 = "sha256-8T/+faVsmgghjxC4SkXQ5B6KDuhVO9NdwMvu7UDlk/0=";
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
