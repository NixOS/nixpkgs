{
  lib,
  stdenv,
  fetchgit,
  callPackage,
  callPackages,
  cmake,
  ninja,
  flex,
  bison,
  zlib,
  tcl,
  boost,
  eigen,
  yaml-cpp,
  libunwind,
  glog,
  gtest,
  gflags,
  metis,
  gmp,
  python3,
  onnxruntime,
}:
let
  rootSrc = stdenv.mkDerivation {
    pname = "iEDA-src";
    version = "2024-09-10";
    src = fetchgit {
      url = "https://gitee.com/oscc-project/iEDA";
      rev = "a8f8e59f6d2a9216974482defb7ed640aca755fc";
      sha256 = "sha256-U2S/DYo+18ks0zzjOdcnQvcbA0ItBHZ0mKVkavav9+0=";
    };

    patches = [
      ./fix-bump-gcc.patch

      # We need to build rust projects with rustPlatform
      # and remove hard coded linking to libonnxruntime
      ./remove-subprojects-from-cmake.patch
    ];

    dontBuild = true;
    dontFixup = true;
    installPhase = ''
      cp -r . $out
    '';

  };

  rustpkgs = callPackages ./rustpkgs.nix { inherit rootSrc; };
in
stdenv.mkDerivation {
  pname = "iEDA";
  version = "0-unstable-2024-09-10";

  src = rootSrc;

  nativeBuildInputs = [
    cmake
    ninja
    flex
    bison
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "CMD_BUILD" true)
    (lib.cmakeBool "SANITIZER" false)
    (lib.cmakeBool "BUILD_STATIC_LIB" false)
  ];

  preConfigure = ''
    cmakeFlags+=" -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:FILEPATH=$out/bin -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:FILEPATH=$out/lib"
  '';

  buildInputs = [
    rustpkgs.iir-rust
    rustpkgs.sdf_parse
    rustpkgs.spef-parser
    rustpkgs.vcd_parser
    rustpkgs.verilog-parser
    rustpkgs.liberty-parser
    tcl
    gtest
    glog
    gflags
    boost
    onnxruntime
    eigen
    yaml-cpp
    libunwind
    metis
    gmp
    python3
  ];

  postInstall = ''
    # Tests rely on hardcoded path, so they should not be included
    rm $out/bin/*test $out/bin/*Test $out/bin/test_*
  '';

  enableParallelBuild = true;

  meta = {
    description = "An open-source EDA infracstructure and tools from Netlist to GDS for ASIC design";
    homepage = "https://gitee.com/oscc-project/iEDA";
    license = lib.licenses.mulan-psl2;
    maintainers = with lib.maintainers; [ xinyangli ];
    mainProgram = "iEDA";
    platforms = lib.platforms.all;
  };
}
