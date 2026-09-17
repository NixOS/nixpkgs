{
  lib,
  stdenv,
  buildPackages,
  autoreconfHook,
  fetchpatch,
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
  pkgsHostHost,
  libpsm2,
  libfabric,
  pmix,
  ucx,
  ucc,
  prrte,
  makeWrapper,
  python3,
  pkg-config,
  config,
  # Enable CUDA support
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  # Enable ROCm support
  rocmSupport ? config.rocmSupport,
  rocmPackages,
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

assert cudaSupport -> !rocmSupport;

let
  crossFortranSupported = stdenv.hostPlatform.emulatorAvailable buildPackages;
  crossFortran =
    fortranSupport && stdenv.buildPlatform != stdenv.hostPlatform && crossFortranSupported;

  # Installed MPI wrappers compile and link against HOST's MPI libraries.
  runtimeCC =
    if stdenv.buildPlatform == stdenv.hostPlatform then
      stdenv.cc
    else
      pkgsHostHost.targetPackages.stdenv.cc;
  runtimeFC = gfortran.__spliced.hostHost or gfortran;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openmpi";
  version = "5.0.10";

  # Cross installs cannot run HOST's shared-library cache updater on BUILD.
  ${if stdenv.buildPlatform != stdenv.hostPlatform then "installFlags" else null} = [
    "LIBTOOLFLAGS=--no-finish"
  ];

  src = fetchurl {
    url = "https://www.open-mpi.org/software/ompi/v${lib.versions.majorMinor finalAttrs.version}/downloads/openmpi-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-Cs7MT8IY5d69vLikHRgsaw8dKTkwFe12OyqR1dc3TMY=";
  };

  patches = [
    # Distinguish IEEE binary128 from equally sized x87 long double throughout
    # datatype conversion and reductions (Open MPI 5.0.x upstream backport).
    (fetchpatch {
      url = "https://github.com/open-mpi/ompi/pull/13714.patch";
      hash = "sha256-sv8bnYqVdrWR2j68NRwViq3gGhtxu4vk3e/hb94Qynk=";
    })
    # Complete quad-complex operations and preserve long-double external32
    # conversion alongside the upstream datatype separation.
    ./float128-complex-and-external32.patch
    ./cuda-diagnostic-formats.patch
  ]
  ++ lib.optionals crossFortran [ ./fortran-cross-probes.patch ];

  postPatch = ''
    patchShebangs ./
  '';

  # Retain the bundled dependency configure scripts and generated component
  # lists while regenerating the top-level datatype checks and headers.
  autoreconfFlags = [
    "--install"
    "--force"
    "--verbose"
    "--no-recursive"
    "-I"
    "config"
    "-I"
    "config/oac"
  ];
  preAutoreconf = ''
    autom4te --language=m4sh -I config config/opal_get_version.m4sh > config/opal_get_version.sh
    chmod +x config/opal_get_version.sh
    patchShebangs config/opal_get_version.sh
  '';

  postAutoreconf =
    lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform && stdenv.hostPlatform.isLinux) ''
      # The libnl ABI-conflict check needs transitive ELF dependencies. ldd would
      # execute HOST's loader; lddtree reads the same dependency graph on BUILD.
      substituteInPlace configure \
        --replace-fail 'ldd conftest' '${lib.getExe' buildPackages.pax-utils "lddtree"} conftest'
    ''
    + ''

      # This is dynamically detected. Configure does not provide fine grained options
      # We just disable the check in the configure script for now
      ${lib.pipe (finalAttrs.passthru.defaultAvxOptions // avxOptions) [
        (lib.mapAttrsToList (
          option: val: ''
            substituteInPlace configure \
              --replace-fail \
                ompi_cv_op_avx_check_${option}=yes \
                ompi_cv_op_avx_check_${option}=${lib.boolToYesNo val}
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
  }
  // lib.optionalAttrs crossFortran {
    # Execute only the original Fortran ABI probes, keeping all other
    # configure logic in cross-compilation mode.
    OMPI_FORTRAN_RUNNER = stdenv.hostPlatform.emulator buildPackages;
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
  ++ lib.optionals rocmSupport (
    with rocmPackages;
    [
      rocm-core
      rocm-runtime
      rocm-device-libs
      clr
    ]
  )
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
    pkg-config
    autoreconfHook
  ]
  ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ]
  ++ lib.optionals fortranSupport [ gfortran ];

  configureFlags = [
    (lib.enableFeature cudaSupport "mca-dso")
    (lib.enableFeature fortranSupport "mpi-fortran")
    (lib.withFeatureAs stdenv.hostPlatform.isLinux "libnl" (lib.getDev libnl))
    # From some reason, without this the darwin build fails with cyclic
    # references between $dev and $out
    "--with-pmix=${lib.getDev pmix}"
    # Puts a "default OMPI_PRTERUN" value to mpirun / mpiexec executables
    (lib.withFeatureAs true "prrte" (lib.getBin prrte))
    (lib.withFeature enableSGE "sge")
    (lib.enableFeature enablePrefix "mpirun-prefix-by-default")
    # Open MPI probes the CUDA driver API, whose link-time stub is separate
    # from libcudart. The existing CUDA hook removes stub runtime search paths.
    (lib.withFeatureAs cudaSupport "cuda" (
      lib.getOutput cudaPackages.cuda_cudart.outputInclude cudaPackages.cuda_cudart
    ))
    (lib.withFeatureAs cudaSupport "cuda-libdir"
      "${lib.getOutput cudaPackages.cuda_cudart.outputStubs cudaPackages.cuda_cudart}/lib/stubs"
    )
    (lib.enableFeature cudaSupport "dlopen")
    (lib.withFeatureAs rocmSupport "rocm" rocmPackages.clr)
    (lib.withFeatureAs fabricSupport "psm2" (lib.getDev libpsm2))
    (lib.withFeatureAs fabricSupport "ofi" (lib.getDev libfabric))
    # The flag --without-ofi-libdir is not supported from some reason, so we
    # don't use lib.withFeatureAs
  ]
  ++ lib.optionals rocmSupport [ "--with-rocm-libdir=${lib.getLib rocmPackages.clr}/lib" ]
  ++ lib.optionals fabricSupport [ "--with-ofi-libdir=${lib.getLib libfabric}/lib" ];

  postConfigure = lib.optionalString cudaSupport ''
    # Upstream can silently disable CUDA even with --with-cuda requested.
    grep -q '^#define OPAL_CUDA_SUPPORT 1$' opal/include/opal_config.h || {
      echo "Open MPI did not enable the requested CUDA support" >&2
      exit 1
    }
  '';

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
          (lib.getExe' runtimeCC "${runtimeCC.targetPrefix}cc")
        ];
        "c++" = [
          # Same as with $CC
          "$CXX"
          (lib.getExe' runtimeCC "${runtimeCC.targetPrefix}c++")
        ];
      }
      // lib.optionalAttrs fortranSupport {
        "fort" = [
          "$FC"
          (lib.getExe' runtimeFC "${runtimeFC.targetPrefix}gfortran")
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

      # Fortran .mod files end up in bin output.
      # Force all headers into the dev output .
      moveToOutput "include/" "''${!outputDev}"

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
      # These wrappers run on HOST and compile against HOST's MPI libraries.
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
    inherit cudaSupport rocmSupport;
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
    # Cross Fortran ABI probes need an emulator for the selected HOST platform.
    broken =
      fortranSupport && !stdenv.buildPlatform.canExecute stdenv.hostPlatform && !crossFortranSupported;
  };
})
