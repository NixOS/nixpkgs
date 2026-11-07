#  mpiCheckPhaseHook {#setup-hook-mpi-check}


This hook can be used to setup a check phase that
requires running a MPI application. It detects the
present MPI implementation type and exports
the necessary environment variables to use
`mpirun` and `mpiexec` in a Nix sandbox.


Example:

```nix
{ mpiCheckPhaseHook, mpi, ... }:
{
  # ...

  nativeCheckInputs = [
    openssh
    mpiCheckPhaseHook
  ];
}
```


