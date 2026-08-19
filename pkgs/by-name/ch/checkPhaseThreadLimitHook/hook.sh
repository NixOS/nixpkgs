setupThreadLimit() {
  # Limit number of threads used during checks. Default is "all cores".
  # Using all cores causes high load on builders if checks are executed with NIX_BUILD_CORE parallelism.
  # This gets even worse if multiple builds are scheduled on the same machine, potentially growing O(n^3) without explicit core limits.

  # global value to override all of these at once
  NIX_CHECK_PHASE_DEFAULT_NUM_THREADS="${NIX_CHECK_PHASE_DEFAULT_NUM_THREADS:-1}"

  thread_vars=(
    OMP_NUM_THREADS
    OPENBLAS_NUM_THREADS
    MKL_NUM_THREADS
    BLIS_NUM_THREADS
    VECLIB_MAXIMUM_THREADS
    NUMBA_NUM_THREADS
    NUMEXPR_NUM_THREADS
  )

  echo "setting known thread variables to default: $NIX_CHECK_PHASE_DEFAULT_NUM_THREADS"
  for var in "${thread_vars[@]}"; do
    export "$var=${!var:-$NIX_CHECK_PHASE_DEFAULT_NUM_THREADS}"
    printf " %s=%s" "$var" "${!var}"
  done
  printf "\n"
}


if [[ -z "${dontLimitCheckPhaseThreads-}" ]]; then
    echo "Using checkPhaseThreadLimitHook"
    preCheckHooks+=('setupThreadLimit')
    preInstallCheckHooks+=('setupThreadLimit')
fi
