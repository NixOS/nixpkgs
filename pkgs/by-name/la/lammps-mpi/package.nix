{
  lib,
  lammps,
  mpi,
}:

lib.lowPrio (
  lammps.override {
    extraNativeBuildInputs = [
      mpi
    ];
    extraCmakeFlags = {
      BUILD_MPI = "ON";
    };
  }
)
