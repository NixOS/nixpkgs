{ stdenv, fetchFromGitLab, cmake, perl, python3, boost, valgrind
# Optional requirements
# Lua 5.3 needed and not available now
#, luaSupport ? false, lua5
, fortranSupport ? false, gfortran
, buildDocumentation ? false, transfig, ghostscript, doxygen
, buildJavaBindings ? false, openjdk
, modelCheckingSupport ? false, libunwind, libevent, elfutils # Inside elfutils: libelf and libdw
, debug ? false
, moreTests ? false
}:

with stdenv.lib;

let
  optionOnOff = option: "${if option then "on" else "off"}";
in

stdenv.mkDerivation rec {
  pname = "simgrid";
  version = "3.22.2";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "02zzivp3k7n2yvlr79p9kapzxpxq9x4x7jf2vrkpkwnssv4f9b4p";
  };

  nativeBuildInputs = [ cmake perl python3 boost valgrind ]
      ++ optionals fortranSupport [ gfortran ]
      ++ optionals buildJavaBindings [ openjdk ]
      ++ optionals buildDocumentation [ transfig ghostscript doxygen ]
      ++ optionals modelCheckingSupport [ libunwind libevent elfutils ];

  #buildInputs = optional luaSupport lua5;

  # Make it so that libsimgrid.so will be found when running programs from
  # the build dir.
  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/build/lib"
  '';

  # Release mode is not supported in SimGrid
  cmakeBuildType = "Debug";

  # Disable/Enable functionality
  # Note: those packages are not packaged in Nixpkgs yet so some options
  # are disabled:
  # - papi:   for enable_smpi_papi
  # - ns3:    for enable_ns3
  # - lua53:  for enable_lua
  #
  # For more information see:
  # https://simgrid.org/doc/3.22/Installing_SimGrid.html#simgrid-compilation-options)
  cmakeFlags= ''
    -Denable_documentation=${optionOnOff buildDocumentation}
    -Denable_java=${optionOnOff buildJavaBindings}
    -Denable_fortran=${optionOnOff fortranSupport}
    -Denable_model-checking=${optionOnOff modelCheckingSupport}
    -Denable_ns3=off
    -Denable_lua=off
    -Denable_lib_in_jar=off
    -Denable_maintainer_mode=off
    -Denable_mallocators=on
    -Denable_debug=on
    -Denable_smpi=on
    -Denable_smpi_ISP_testsuite=${optionOnOff moreTests}
    -Denable_smpi_MPICH3_testsuite=${optionOnOff moreTests}
    -Denable_compile_warnings=${optionOnOff debug}
    -Denable_compile_optimizations=${optionOnOff (!debug)}
    -Denable_lto=${optionOnOff (!debug)}
  '';
  # -Denable_lua=${optionOnOff luaSupport}
  # -Denable_smpi_papi=${optionOnOff moreTests}

  makeFlags = optionalString debug "VERBOSE=1";

  # Some Perl scripts are called to generate test during build which
  # is before the fixupPhase, so do this manualy here:
  preBuild = ''
    patchShebangs ..
  '';

  doCheck = true;

  # Prevent the execution of tests known to fail.
  preCheck = ''
    cat <<EOW >CTestCustom.cmake
    SET(CTEST_CUSTOM_TESTS_IGNORE smpi-replay-multiple)
    EOW
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Framework for the simulation of distributed applications";
    longDescription = ''
      SimGrid is a toolkit that provides core functionalities for the
      simulation of distributed applications in heterogeneous distributed
      environments.  The specific goal of the project is to facilitate
      research in the area of distributed and parallel application
      scheduling on distributed computing platforms ranging from simple
      network of workstations to Computational Grids.
    '';
    homepage = https://simgrid.org/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ mickours ];
    platforms = ["x86_64-linux"];
  };
}
