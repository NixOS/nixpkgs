# nixpkgs-update: no auto update
# updated via the parent 'qsv' derivation
{ qsv }:
qsv.override {
  buildFeatures = [ "lite" ];
  mainProgram = "qsvlite";
}
