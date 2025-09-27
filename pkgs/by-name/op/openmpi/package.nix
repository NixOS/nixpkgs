{
  lib,
  stdenv,
  fetchurl,
  removeReferencesTo,
  gfortran,
  perl,
  libnl,
  rdma-core,
  zlib,
  numactl,
  libevent,
  hwloc,
  targetPackages,
  libpsm2,
  libfabric,
  pmix,
  ucx,
  ucc,
  prrte,
  makeWrapper,
  python3,
  config,
  # Enable CUDA support
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  # Enable the Sun Grid Engine bindings
  enableSGE ? false,
  # Pass PATH/LD_LIBRARY_PATH to point to current mpirun by default
  enablePrefix ? false,
  # Enable libfabric support (necessary for Omnipath networks) on x86_64 linux
  fabricSupport ? stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64,
  # Enable Fortran support
  fortranSupport ? true,
  # AVX/SSE options. See passthru.defaultAvxOptions for the available options.
  # note that opempi fails to build with AVX disabled, meaning that everything
  # up to AVX is enabled by default.
  avxOptions ? { },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openmpi";
  version = "5.0.8";

  src = fetchurl {
    url = "https://www.open-mpi.org/software/ompi/v${lib.versions.majorMinor finalAttrs.version}/downloads/openmpi-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-UxMeGlfnJw9kVwf4sLZbpWBI9bWsP2j6q+0+sNcQ5Ek=";
  };

  postPatch = ''
    patchShebangs ./

    # This is dynamically detected. Configure does not provide fine grained options
    # We just disable the check in the configure script for now
    ${lib.pipe (finalAttrs.passthru.defaultAvxOptions // avxOptions) [
      (lib.mapAttrsToList (
        option: val: ''
          substituteInPlace configure \
            --replace-fail \
              ompi_cv_op_avx_check_${option}=yes \
              ompi_cv_op_avx_check_${option}=${if val then "yes" else "no"}
        ''
      ))
      (lib.concatStringsSep "\n")
    ]}
  '';

  # Ensure build is reproducible according to manual
  # https://docs.open-mpi.org/en/v5.0.x/release-notes/general.html#general-notes
  env = {
    USER = "nixbld";
    HOSTNAME = "localhost";
  };

  outputs = [
    "out"
    "man"
    "dev"
  ];

  buildInputs = [
    zlib
    libevent
    hwloc
    prrte
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libnl
    numactl
    pmix
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform ucx) [
    ucx
    ucc
  ]
  ++ lib.optionals cudaSupport [ cudaPackages.cuda_cudart ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isFreeBSD) [ rdma-core ]
  # needed for internal pmix
  ++ lib.optionals (!stdenv.hostPlatform.isLinux) [ python3 ]
  ++ lib.optionals fabricSupport [
    libpsm2
    libfabric
  ];

  nativeBuildInputs = [
    perl
    removeReferencesTo
    makeWrapper
  ]
  ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ]
  ++ lib.optionals fortranSupport [ gfortran ];

  configureFlags = [
    (lib.enableFeature cudaSupport "mca-dso")
    (lib.enableFeature fortranSupport "mpi-fortran")
    (lib.withFeatureAs stdenv.hostPlatform.isLinux "libnl" (lib.getDev libnl))
    "--with-pmix=${lib.getDev pmix}"
    "--with-pmix-libdir=${lib.getLib pmix}/lib"
    # Puts a "default OMPI_PRTERUN" value to mpirun / mpiexec executables
    (lib.withFeatureAs true "prrte" (lib.getBin prrte))
    (lib.withFeature enableSGE "sge")
    (lib.enableFeature enablePrefix "mpirun-prefix-by-default")
    # TODO: add UCX support, which is recommended to use with cuda for the most robust OpenMPI build
    # https://github.com/openucx/ucx
    # https://www.open-mpi.org/faq/?category=buildcuda
    (lib.withFeatureAs cudaSupport "cuda" (lib.getDev cudaPackages.cuda_cudart))
    (lib.withFeatureAs cudaSupport "cuda-libdir" "${cudaPackages.cuda_cudart.stubs}/lib")
    (lib.enableFeature cudaSupport "dlopen")
    (lib.withFeatureAs fabricSupport "psm2" (lib.getDev libpsm2))
    (lib.withFeatureAs fabricSupport "ofi" (lib.getDev libfabric))
    # The flag --without-ofi-libdir is not supported from some reason, so we
    # don't use lib.withFeatureAs
  ]
  ++ lib.optionals fabricSupport [ "--with-ofi-libdir=${lib.getLib libfabric}/lib" ];

  enableParallelBuilding = true;

  postInstall =
    let
      # The file names we need to iterate are a combination of ${p}${s}, and there
      # are 7x3 such options. We use lib.mapCartesianProduct to iterate them all.
      fileNamesToIterate = {
        p = [
          "mpi"
        ]
        ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform ucx) [
          "shmem"
          "osh"
        ];
        s = [
          "c++"
          "cxx"
          "cc"
        ]
        ++ lib.optionals fortranSupport [
          "f77"
          "f90"
          "fort"
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [ "CC" ];
      };
      wrapperDataSubstitutions = {
        # The attr key is the filename prefix. The list's 1st value is the
        # compiler=_ line that should be replaced by a compiler=#2 string, where
        # #2 is the 2nd value in the list.
        "cc" = [
          # "$CC" is expanded by the executing shell in the substituteInPlace
          # commands to the name of the compiler ("clang" for Darwin and
          # "gcc" for Linux)
          "$CC"
          "${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}$CC"
        ];
        "c++" = [
          # Same as with $CC
          "$CXX"
          "${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}$CXX"
        ];
      }
      // lib.optionalAttrs fortranSupport {
        "fort" = [
          "gfortran"
          "${targetPackages.gfortran or gfortran}/bin/${
            targetPackages.gfortran.targetPrefix or gfortran.targetPrefix
          }gfortran"
        ];
      };
      # The -wrapper-data.txt files that are not symlinks, need to be iterated as
      # well, here they start withw ${part1}${part2}, and we use
      # lib.mapCartesianProduct as well.
      wrapperDataFileNames = {
        part1 = [
          "mpi"
        ]
        ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform ucx) [ "shmem" ];
        part2 = builtins.attrNames wrapperDataSubstitutions;
      };
    in
    ''
      find $out/lib/ -name "*.la" -exec rm -f \{} \;

      # The main wrapper that all the rest of the commonly used binaries are
      # symlinked to
      moveToOutput "bin/opal_wrapper" "''${!outputDev}"
      # All of the following files are symlinks to opal_wrapper
      ${lib.pipe fileNamesToIterate [
        (lib.mapCartesianProduct (
          { p, s }:
          ''
            echo "handling ${p}${s}"
            moveToOutput "bin/${p}${s}" "''${!outputDev}"
            moveToOutput "share/openmpi/${p}${s}-wrapper-data.txt" "''${!outputDev}"
          ''
        ))
        (lib.concatStringsSep "\n")
      ]}
      # default compilers should be indentical to the
      # compilers at build time
      ${lib.pipe wrapperDataFileNames [
        (lib.mapCartesianProduct (
          { part1, part2 }:
          ''
            substituteInPlace "''${!outputDev}/share/openmpi/${part1}${part2}-wrapper-data.txt" \
              --replace-fail \
                compiler=${lib.elemAt wrapperDataSubstitutions.${part2} 0} \
                compiler=${lib.elemAt wrapperDataSubstitutions.${part2} 1}
          ''
        ))
        (lib.concatStringsSep "\n")
      ]}

      # Handle informative binaries about the compilation
      ${lib.pipe wrapperDataFileNames.part1 [
        (map (name: ''
          moveToOutput "bin/o${name}_info" "''${!outputDev}"
        ''))
        (lib.concatStringsSep "\n")
      ]}
    '';

  postFixup = ''
    remove-references-to -t "''${!outputMan}" $(readlink -f $out/lib/libopen-pal${stdenv.hostPlatform.extensions.library})
    remove-references-to -t "''${!outputDev}" $out/bin/mpirun
    remove-references-to -t "''${!outputDev}" $(readlink -f $out/lib/libopen-pal${stdenv.hostPlatform.extensions.library})

    # The path to the wrapper is hard coded in libopen-pal.so, which we just cleared.
    wrapProgram "''${!outputDev}/bin/opal_wrapper" \
      --set OPAL_INCLUDEDIR "''${!outputDev}/include" \
      --set OPAL_PKGDATADIR "''${!outputDev}/share/openmpi"
  '';

  doCheck = true;

  passthru = {
    defaultAvxOptions = {
      sse3 = true;
      sse41 = true;
      avx = true;
      avx2 = stdenv.hostPlatform.avx2Support;
      avx512 = stdenv.hostPlatform.avx512Support;
    };
    inherit cudaSupport;
    cudatoolkit = cudaPackages.cudatoolkit; # For backward compatibility only
  };

  meta = {
    homepage = "https://www.open-mpi.org/";
    description = "Open source MPI-3 implementation";
    longDescription = "The Open MPI Project is an open source MPI-3 implementation that is developed and maintained by a consortium of academic, research, and industry partners. Open MPI is therefore able to combine the expertise, technologies, and resources from all across the High Performance Computing community in order to build the best MPI library available. Open MPI offers advantages for system and software vendors, application developers and computer science researchers.";
    maintainers = with lib.maintainers; [
      markuskowa
      doronbehar
    ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    # checking size of Fortran CHARACTER... configure: error: Can not determine size of CHARACTER when cross-compiling
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
})
