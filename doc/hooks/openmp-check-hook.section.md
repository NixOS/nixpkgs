# openmpCheckPhaseHook {#setup-hook-omp-check}


This hook can be used to setup a check phase that
requires running a OpenMP application. It mostly
serves to limit `OMP_NUM_THREADS` to avoid overloading
build machines.

This hook will not attempt to override an already existing
definition of `OMP_NUM_THREADS` in the environment.
