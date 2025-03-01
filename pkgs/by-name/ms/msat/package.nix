{ ocamlPackages }:

with ocamlPackages;
buildDunePackage {
  pname = "msat-bin";

  inherit (msat) version src;

  buildInputs = [
    camlzip
    containers
    msat
  ];

  meta = msat.meta // {
    description = "SAT solver binary based on the msat library";
    mainProgram = "msat";
  };
}
