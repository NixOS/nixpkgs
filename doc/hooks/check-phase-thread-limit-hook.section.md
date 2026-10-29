# checkPhaseThreadLimitHook {#setup-hook-check-phase-thread-limit}

This hook defaults a variety of environment variables known
to control thread counts to 1. Many of these otherwise default
to `$(nproc)`, which causes massive overloads on build machines
if nix build jobs and build cores are already tuned to fully utilize
compute capacity of a builder without additional parallelism.

Currently sets the following environment variables:
- [`OMP_NUM_THREADS`](https://www.openmp.org/spec-html/5.0/openmpse50.html)
- [`OPENBLAS_NUM_THREADS`](https://github.com/OpenMathLib/OpenBLAS/blob/e7b45174355edec1f04de1cabcf5ca6a98ea7fbc/USAGE.md#how-can-i-use-openblas-in-multi-threaded-applications)
- [`MKL_NUM_THREADS`](https://www.intel.com/content/www/us/en/docs/onemkl/developer-guide-linux/2023-0/mkl-domain-num-threads.html)
- [`BLIS_NUM_THREADS`](https://github.com/flame/blis/blob/b8b75b4e19459f5d618b57aa814ca38b1d82eb82/docs/Multithreading.md#specifying-multithreading)
- `VECLIB_MAXIMUM_THREADS`: Only affects darwin, see [`man 7 Accelerate`](https://manp.gs/mac/7/Accelerate)
- [`NUMBA_NUM_THREADS`](https://numba.readthedocs.io/en/stable/reference/envvars.html#threading-control)
- [`NUMEXPR_NUM_THREADS`](https://numexpr.readthedocs.io/en/latest/user_guide.html#threadpool-configuration)

The `NIX_CHECK_PHASE_DEFAULT_NUM_THREADS` environment variable
can be used to override the default thread count limit.
`dontLimitCheckPhaseThreads = true;` can be used to disable
thread limiting on an individual package.

This hook will not attempt to override already existing
definitions for thread count environment variables.
