{
  lammps,
  mpi,
  lowPrio,
}:

lowPrio (
  lammps.override {
    extraBuildInputs = [
      mpi
    ];
  }
)
