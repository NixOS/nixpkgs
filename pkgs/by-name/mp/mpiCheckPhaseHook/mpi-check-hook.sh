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
      # Note, that openmpi-5 switched to using PRRTE.
      # Thus we need to set PRTE_MCA_* instead of OMPI_MCA_*.
      # We keep the openmpi-4 parameters for backward compatability.

      # Make sure the test starts even if we have less than the requested amount of cores
      export OMPI_MCA_rmaps_base_oversubscribe=1
      export PRTE_MCA_rmaps_default_mapping_policy=node:oversubscribe

      # Make sure we do not need openssh in the checkPhase
      export OMPI_MCA_plm_ssh_agent=false
      export PRRTE_MCA_plm_ssh_agent=false

      # Disable CPU pinning
      export OMPI_MCA_hwloc_base_binding_policy=none
      export PRTE_MCA_hwloc_default_binding_policy=none

      # OpenMPI get confused by the sandbox environment and spew errors like this (both to stdout and stderr):
      #     [hwloc/linux] failed to find sysfs cpu topology directory, aborting linux discovery.
      #     [1729458724.473282] [localhost:78   :0]       tcp_iface.c:893  UCX  ERROR scandir(/sys/class/net) failed: No such file or directory
      # These messages contaminate test output, which makes the difftest to fail.
      # The solution is to use a preset cpu topology file and disable ucx model.

      # Disable sysfs cpu topology directory discovery.
      export HWLOC_XMLFILE="@topology@"
      # Use the network model ob1 instead of ucx.
      export OMPI_MCA_pml=ob1
      ;;
    MPICH)
      # Fix to make mpich run in a sandbox
      export HYDRA_IFACE="@iface@"
      # Disable sysfs cpu topology directory discovery.
      export HWLOC_XMLFILE="@topology@"
      ;;
    MVAPICH)
      # Disable CPU pinning
      export MV2_ENABLE_AFFINITY=0
      # Disable sysfs cpu topology directory discovery.
      export HWLOC_XMLFILE="@topology@"
      ;;
  esac

  # Limit number of OpenMP threads. Default is "all cores".
  export OMP_NUM_THREADS=1
}

