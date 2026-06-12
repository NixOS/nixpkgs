{
  gnuplot,
  noMaintainersNorDependents,
}:

noMaintainersNorDependents (
  gnuplot.override {
    aquaterm = true;
  }
)
