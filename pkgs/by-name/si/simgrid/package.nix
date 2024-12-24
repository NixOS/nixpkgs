{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  perl,
  python3,
  boost,
  fortranSupport ? false,
  gfortran,
  buildDocumentation ? false,
  fig2dev,
  ghostscript,
  doxygen,
  buildJavaBindings ? false,
  openjdk,
  buildPythonBindings ? true,
  python3Packages,
  modelCheckingSupport ? false,
  libunwind,
  libevent,
  elfutils, # Inside elfutils: libelf and libdw
  bmfSupport ? true,
  eigen,
  minimalBindings ? false,
  debug ? false,
  optimize ? (!debug),
  moreTests ? false,
  withoutBin ? false,
}:

stdenv.mkDerivation rec {
  pname = "simgrid";
  version = "3.36";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7w4ObbMem1Y8Lh9MOcdCSEktTDRkvVKmKlS9adm15oE=";
  };

  propagatedBuildInputs = [ boost ];
  nativeBuildInputs =
    [
      cmake
      perl
      python3
    ]
    ++ lib.optionals fortranSupport [ gfortran ]
    ++ lib.optionals buildJavaBindings [ openjdk ]
    ++ lib.optionals buildPythonBindings [ python3Packages.pybind11 ]
    ++ lib.optionals buildDocumentation [
      fig2dev
      ghostscript
      doxygen
    ]
    ++ lib.optionals bmfSupport [ eigen ]
    ++ lib.optionals modelCheckingSupport [
      libunwind
      libevent
      elfutils
    ];

  outputs = [ "out" ] ++ lib.optionals buildPythonBindings [ "python" ];

  # "Release" does not work. non-debug mode is Debug compiled with optimization
  cmakeBuildType = "Debug";

  cmakeFlags = [
    (lib.cmakeBool "enable_documentation" buildDocumentation)
    (lib.cmakeBool "enable_java" buildJavaBindings)
    (lib.cmakeBool "enable_python" buildPythonBindings)
    (lib.cmakeFeature "SIMGRID_PYTHON_LIBDIR" "./") # prevents CMake to install in ${python3} dir
    (lib.cmakeBool "enable_msg" buildJavaBindings)
    (lib.cmakeBool "enable_fortran" fortranSupport)
    (lib.cmakeBool "enable_model-checking" modelCheckingSupport)
    (lib.cmakeBool "enable_ns3" false)
    (lib.cmakeBool "enable_lua" false)
    (lib.cmakeBool "enable_lib_in_jar" false)
    (lib.cmakeBool "enable_maintainer_mode" false)
    (lib.cmakeBool "enable_mallocators" true)
    (lib.cmakeBool "enable_debug" true)
    (lib.cmakeBool "enable_smpi" true)
    (lib.cmakeBool "minimal-bindings" minimalBindings)
    (lib.cmakeBool "enable_smpi_ISP_testsuite" moreTests)
    (lib.cmakeBool "enable_smpi_MPICH3_testsuite" moreTests)
    (lib.cmakeBool "enable_compile_warnings" false)
    (lib.cmakeBool "enable_compile_optimizations" optimize)
    (lib.cmakeBool "enable_lto" optimize)
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" optimize)
  ];

  makeFlags = lib.optional debug "VERBOSE=1";

  # needed to run tests and to ensure correct shabangs in output scripts
  preBuild = ''
    patchShebangs ..
  '';

  # needed by tests (so libsimgrid.so is found)
  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/build/lib"
  '';

  doCheck = true;
  preCheck = ''
    # prevent the execution of tests known to fail
    cat <<EOW >CTestCustom.cmake
    SET(CTEST_CUSTOM_TESTS_IGNORE smpi-replay-multiple)
    EOW

    # make sure tests are built in parallel (this can be long otherwise)
    make tests -j $NIX_BUILD_CORES
  '';

  postInstall =
    lib.optionalString withoutBin ''
      # remove bin from output if requested.
      # having a specific bin output would be cleaner but it does not work currently (circular references)
      rm -rf $out/bin
    ''
    + lib.optionalString buildPythonBindings ''
      # manually install the python binding if requested.
      mkdir -p $python/lib/python${lib.versions.majorMinor python3.version}/site-packages/
      cp ./lib/simgrid.cpython*.so $python/lib/python${lib.versions.majorMinor python3.version}/site-packages/
    '';

  # improve debuggability if requested
  hardeningDisable = lib.optionals debug [ "fortify" ];
  dontStrip = debug;

  meta = with lib; {
    description = "Framework for the simulation of distributed applications";
    longDescription = ''
      SimGrid is a toolkit that provides core functionalities for the
      simulation of distributed applications in heterogeneous distributed
      environments.  The specific goal of the project is to facilitate
      research in the area of distributed and parallel application
      scheduling on distributed computing platforms ranging from simple
      network of workstations to Computational Grids.
    '';
    homepage = "https://simgrid.org/";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [
      mickours
      mpoquet
    ];
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
