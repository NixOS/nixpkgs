{ qsv }:
qsv.override {
  buildFeatures = [ "lite" ];
  mainProgram = "qsvlite";
}
