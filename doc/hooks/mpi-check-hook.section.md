#  mpiCheckPhaseHook {#setup-hook-mpi-check}


This hook can be used to setup a check phase that
requires running a MPI application. It detects the
used present MPI implementaion type and exports
the neceesary environment variables to use
`mpirun` and `mpiexec` in a Nix sandbox.


Example:

```nix
  { mpiCheckPhaseHook, mpi, ... }:

  ...

  nativeCheckInputs = [
    openssh
    mpiCheckPhaseHook
  ];
```


