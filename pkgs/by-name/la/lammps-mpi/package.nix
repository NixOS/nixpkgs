{
  lib,
  lammps,
  mpi,
}:

lib.lowPrio (
  lammps.override {
    extraBuildInputs = [
      mpi
    ];
  }
)
