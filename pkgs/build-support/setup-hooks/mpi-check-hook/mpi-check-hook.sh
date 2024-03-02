preCheckHooks+=('setupMpiCheck')
preInstallCheckHooks+=('setupMpiCheck')


setupMpiCheck() {
  # Find out which MPI implementation we are using
  # and set safe defaults that are guaranteed to run
  # on any build machine

  mpiType="NONE"

  # OpenMPI signature
  if command ompi_info &> /dev/null; then
    mpiType="openmpi"
  fi

  # MPICH based implementations
  if command mpichversion &> /dev/null; then
    if [ "$mpiType" != "NONE" ]; then
      echo "WARNING: found OpenMPI and MPICH/MVAPICH executables"
    fi

    version=$(mpichversion)
    if [[ "$version" == *"MPICH"* ]]; then
      mpiType="MPICH"
    fi
    if [[ "$version" == *"MVAPICH"* ]]; then
      mpiType="MVAPICH"
    fi
  fi

  echo "Found MPI implementation: $mpiType"

  case $mpiType in
    openmpi)
      # make sure the test starts even if we have less than the requested amount of cores
      export OMPI_MCA_rmaps_base_oversubscribe=1
      # Disable CPU pinning
      export OMPI_MCA_hwloc_base_binding_policy=none
      ;;
    MPICH)
      # Fix to make mpich run in a sandbox
      export HYDRA_IFACE=lo
      ;;
    MVAPICH)
      # Disable CPU pinning
      export MV2_ENABLE_AFFINITY=0
      ;;
  esac

  # Limit number of OpenMP threads. Default is "all cores".
  export OMP_NUM_THREADS=1
}

