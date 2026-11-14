{ paraview }:

# Without the Qt GUI and MPI: pvpython/pvbatch/pvserver for offscreen
# (EGL) rendering on servers and in sandboxes.
(paraview.override {
  withQt = false;
  mpiSupport = false;
}).overrideAttrs
  { pname = "paraview-headless"; }
