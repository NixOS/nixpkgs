{ lib
, stdenv
, fetchFromGitHub
, mpiCheckPhaseHook
, python3
, gfortran
, blas
, lapack
, fftw
, libint
, libvori
, libxc
, mpi
, gsl
, scalapack
, openssh
, makeWrapper
, libxsmm
, spglib
, which
, pkg-config
, plumed
, zlib
, hdf5-fortran
, sirius
, libvdwxc
, spla
, spfft
, enableElpa ? false
, elpa
, gpuBackend ? "none"
, cudaPackages
# gpuVersion needs to be set for both CUDA as well as ROCM hardware.
# gpuArch is only required for the ROCM stack.
# Change to a value suitable for your target GPU.
# For AMD values see https://github.com/cp2k/cp2k/blob/master/INSTALL.md#2v-rocmhip-support-for-amd-gpu
# and for Nvidia see https://github.com/cp2k/cp2k/blob/master/INSTALL.md#2i-cuda-optional-improved-performance-on-gpu-systems
, gpuVersion ? "Mi100"
, gpuArch ? "gfx908"
, rocmPackages
}:

assert builtins.elem gpuBackend [ "none" "cuda" "rocm" ];

let
  cp2kVersion = "psmp";
  arch = "Linux-x86-64-gfortran";

in
stdenv.mkDerivation rec {
  pname = "cp2k";
  version = "2023.2";

  src = fetchFromGitHub {
    owner = "cp2k";
    repo = "cp2k";
    rev = "v${version}";
    hash = "sha256-1TJorIjajWFO7i9vqSBDTAIukBdyvxbr5dargt4QB8M=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ python3 which openssh makeWrapper pkg-config ];
  buildInputs = [
    gfortran
    fftw
    gsl
    libint
    libvori
    libxc
    libxsmm
    spglib
    scalapack
    blas
    lapack
    plumed
    zlib
    hdf5-fortran
    sirius
    spla
    spfft
    libvdwxc
  ]
  ++ lib.optional enableElpa elpa
  ++ lib.optional (gpuBackend == "cuda") cudaPackages.cudatoolkit
  ++ lib.optional (gpuBackend == "rocm") [
    rocmPackages.clr
    rocmPackages.rocm-core
    rocmPackages.hipblas
    rocmPackages.hipfft
    rocmPackages.rocblas
  ]
  ;

  propagatedBuildInputs = [ mpi ];
  propagatedUserEnvPkgs = [ mpi ];

  makeFlags = [
    "ARCH=${arch}"
    "VERSION=${cp2kVersion}"
  ];

  doCheck = gpuBackend == "none";

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs tools exts/dbcsr/tools/build_utils exts/dbcsr/.cp2k
    substituteInPlace exts/build_dbcsr/Makefile \
      --replace '/usr/bin/env python3' '${python3}/bin/python' \
      --replace 'SHELL = /bin/sh' 'SHELL = bash'
  '';

  configurePhase = ''
    cat > arch/${arch}.${cp2kVersion} << EOF
    CC         = mpicc
    CPP        =
    FC         = mpif90
    LD         = mpif90
    AR         = ar -r
    ${lib.strings.optionalString (gpuBackend == "cuda") ''
    OFFLOAD_CC = nvcc
    OFFLOAD_FLAGS = -O3 -g -w --std=c++11
    OFFLOAD_TARGET = cuda
    GPUVER = ${gpuVersion}
    CXX = mpicxx
    CXXFLAGS = -std=c++11 -fopenmp
    ''}
    ${lib.strings.optionalString (gpuBackend == "rocm") ''
    GPUVER = ${gpuVersion}
    OFFLOAD_CC = hipcc
    OFFLOAD_FLAGS = -fopenmp -m64 -pthread -fPIC -D__GRID_HIP -O2 --offload-arch=${gpuArch} --rocm-path=${rocmPackages.rocm-core}
    OFFLOAD_TARGET = hip
    CXX = mpicxx
    CXXFLAGS = -std=c++11 -fopenmp -D__HIP_PLATFORM_AMD__
    ''}
    DFLAGS     = -D__FFTW3 -D__LIBXC -D__LIBINT -D__parallel -D__SCALAPACK \
                 -D__MPI_VERSION=3 -D__F2008 -D__LIBXSMM -D__SPGLIB \
                 -D__MAX_CONTR=4 -D__LIBVORI ${lib.optionalString enableElpa "-D__ELPA"} \
                 -D__PLUMED2 -D__HDF5 -D__GSL -D__SIRIUS -D__LIBVDWXC -D__SPFFT -D__SPLA \
                 ${lib.strings.optionalString (gpuBackend == "cuda") "-D__OFFLOAD_CUDA -D__DBCSR_ACC"} \
                 ${lib.strings.optionalString (gpuBackend == "rocm") "-D__OFFLOAD_HIP -D__DBCSR_ACC -D__NO_OFFLOAD_PW"}
    CFLAGS    = -fopenmp -I${lib.getDev hdf5-fortran}/include -I${lib.getDev gsl}/include
    FCFLAGS    = \$(DFLAGS) -O2 -ffree-form -ffree-line-length-none \
                 -ftree-vectorize -funroll-loops -msse2 \
                 -std=f2008 \
                 -fopenmp -ftree-vectorize -funroll-loops \
                 -I${lib.getDev libint}/include ${lib.optionalString enableElpa "$(pkg-config --variable=fcflags elpa)"} \
                 -I${lib.getDev sirius}/include/sirius \
                 -I${lib.getDev libxc}/include -I${lib.getDev libxsmm}/include
    LIBS       = -lfftw3 -lfftw3_threads \
                 -lscalapack -lblas -llapack \
                 -lxcf03 -lxc -lxsmmf -lxsmm -lsymspg \
                 -lint2 -lstdc++ -lvori \
                 -lgomp -lpthread -lm \
                 -fopenmp ${lib.optionalString enableElpa "$(pkg-config --libs elpa)"} \
                 -lz -ldl ${lib.optionalString (mpi.pname == "openmpi") "$(mpicxx --showme:link)"} \
                 -lplumed -lhdf5_fortran -lhdf5_hl -lhdf5 -lgsl -lsirius -lspla -lspfft -lvdwxc \
                 ${lib.strings.optionalString (gpuBackend == "cuda") "-lcudart -lnvrtc -lcuda -lcublas"} \
                 ${lib.strings.optionalString (gpuBackend == "rocm") "-lamdhip64 -lhipfft -lhipblas -lrocblas"}
    LDFLAGS    = \$(FCFLAGS) \$(LIBS)
    include ${plumed}/lib/plumed/src/lib/Plumed.inc
    EOF
  '';

  nativeCheckInputs = [
    mpiCheckPhaseHook
    openssh
  ];

  checkPhase = ''
    runHook preCheck

    export CP2K_DATA_DIR=data
    mpirun -np 2 exe/${arch}/libcp2k_unittest.${cp2kVersion}

    runHook postCheck
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/cp2k

    cp exe/${arch}/* $out/bin
    rm $out/bin/*_unittest.*

    for i in cp2k cp2k_shell graph; do
      wrapProgram $out/bin/$i.${cp2kVersion} \
        --set-default CP2K_DATA_DIR $out/share/cp2k
    done

    wrapProgram $out/bin/cp2k.popt \
      --set-default CP2K_DATA_DIR $out/share/cp2k \
      --set OMP_NUM_THREADS 1

    cp -r data/* $out/share/cp2k
  '';

  passthru = { inherit mpi; };

  meta = with lib; {
    description = "Quantum chemistry and solid state physics program";
    homepage = "https://www.cp2k.org";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.sheepforce ];
    platforms = [ "x86_64-linux" ];
  };
}
