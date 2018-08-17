{ stdenv, fetchFromGitHub, cmake, perl, python3, boost, valgrind
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
  name = "simgrid-${version}";
  version = "3.20";

  src = fetchFromGitHub {
    owner = "simgrid";
    repo = "simgrid";
    rev = "v${version}";
    sha256 = "0xb20qhvsah2dz2hvn850i3w9a5ghsbcx8vka2ap6xsdkxf593gy";
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
  # http://simgrid.gforge.inria.fr/simgrid/latest/doc/install.html#install_cmake_list
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

  checkPhase = ''
    runHook preCheck

    ctest -j $NIX_BUILD_CORES --output-on-failure -E smpi-replay-multiple

    runHook postCheck
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
    homepage = http://simgrid.gforge.inria.fr/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ mickours ];
    platforms = platforms.x86_64;
  };
}
