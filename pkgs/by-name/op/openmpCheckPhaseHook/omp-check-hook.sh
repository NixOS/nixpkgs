preCheckHooks+=('setupOmpCheck')
preInstallCheckHooks+=('setupOmpCheck')


setupOmpCheck() {
  # Limit number of OpenMP threads. Default is "all cores".
  # Using all cores causes high load on builders if checks are executed with NIX_BUILD_CORE parallelism.
  # This gets even worse if multiple builds are scheduled on the same machine, potentially growing O(n^3) without explicit core limits.
  export OMP_NUM_THREADS="${OMP_NUM_THREADS:-1}"
}

