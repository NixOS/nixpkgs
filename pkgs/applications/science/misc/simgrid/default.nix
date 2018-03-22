{ stdenv, fetchFromGitHub, cmake, elfutils, perl, python3, boost, valgrind
# Optional requirements
# Lua 5.3 needed and not available now
#, luaSupport ? false, lua5
, fortranSupport ? false, gfortran
, buildDocumentation ? false, transfig, ghostscript, doxygen
, buildJavaBindings ? false, openjdk
, modelCheckingSupport ? false, libunwind, libevent # Inside elfutils - , libelf, libevent, libdw
, debug ? false
, moreTests ? false
}:

# helpers for options
let optionals       = stdenv.lib.optionals;
    optionalString = stdenv.lib.optionalString;
    optionOnOff = option: "${if option then "on" else "off"}";
in

stdenv.mkDerivation rec {
  major_version = "3";
  minor_version = "17";
  version = "v${major_version}.${minor_version}";
  tagged_version = "${major_version}_${minor_version}";
  name = "simgrid";

  src = fetchFromGitHub {
    owner = "simgrid";
    repo = "simgrid";
    rev = "v3_17";
    sha256 = "0ffs9w141qhw571jsa9sch1cnr332vs4sgj6dsiij2mc24m6wpb4";
    #rev = "master";
    #sha256 = "0qvh1jzc2lpnp8234kjx1x4g1a5kfdn6kb15vhk160qgvj98nyqm";
  };

  nativeBuildInputs = [ cmake perl elfutils python3 boost valgrind]
      ++ optionals fortranSupport [gfortran]
      ++ optionals buildJavaBindings [openjdk]
      ++ optionals buildDocumentation [transfig ghostscript doxygen]
      ++ optionals modelCheckingSupport [libunwind libevent];

  #buildInputs = optional luaSupport lua5;

  preConfigure =
    # Make it so that libsimgrid.so will be found when running programs from
    # the build dir.
    ''
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
       #-Denable_lua=${optionOnOff luaSupport}
       #-Denable_smpi_papi=${optionOnOff moreTests}

  makeFlags = optionalString debug "VERBOSE=1";

  preBuild =
    ''
       # Some perl scripts are called to generate test during build which
       # is before the fixupPhase of nix, so do this manualy here:
       patchShebangs ..
    '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    ctest --output-on-failure -E smpi-replay-multiple

    runHook postCheck
    '';
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Framework for the simulation of distributed applications";
    longDescription =
      '' SimGrid is a toolkit that provides core functionalities for the
         simulation of distributed applications in heterogeneous distributed
         environments.  The specific goal of the project is to facilitate
         research in the area of distributed and parallel application
         scheduling on distributed computing platforms ranging from simple
         network of workstations to Computational Grids.
      '';
    homepage = http://simgrid.gforge.inria.fr/;
    maintainers = with maintainers; [ mickours ];
    platforms = platforms.x86_64;
    license = licenses.lgpl2Plus;
  };
}
