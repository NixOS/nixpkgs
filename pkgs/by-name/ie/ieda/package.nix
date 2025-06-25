{
  lib,
  stdenv,
  fetchgit,
  fetchFromGitHub,
  fetchpatch,
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
  glog-lock = glog.overrideAttrs (oldAttrs: rec {
    version = "0.6.0";
    src = fetchFromGitHub {
      owner = "google";
      repo = "glog";
      rev = "v${version}";
      sha256 = "sha256-xqRp9vaauBkKz2CXbh/Z4TWqhaUtqfbsSlbYZR/kW9s=";
    };
  });
  rootSrc = stdenv.mkDerivation {
    pname = "iEDA-src";
    version = "2025-05-30";
    src = fetchgit {
      url = "https://gitee.com/oscc-project/iEDA";
      rev = "3096147fcea491c381da2928be6fb5a12c2d97b7";
      sha256 = "sha256-rPkcE+QFMlEuwwJ/QBgyLTXP5lWLQPj5SOlZysJ6WTI=";
    };

    patches = [
      # This patch is to fix the build error caused by the missing of the header file,
      # and remove some libs or path that they hard-coded in the source code.
      # Should be removed after we upstream these changes.
      (fetchpatch {
        url = "https://github.com/Emin017/iEDA/commit/e899b432776010048b558a939ad9ba17452cb44f.patch";
        hash = "sha256-fLKsb/dgbT1mFCWEldFwhyrA1HSkKGMAbAs/IxV9pwM=";
      })
      # This patch is to fix the compile error on the newer version of gcc/g++
      # which is caused by some incorrect declarations and usages of the Boost library.
      # Should be removed after we upstream these changes.
      (fetchpatch {
        url = "https://github.com/Emin017/iEDA/commit/3a2c7e27a5bd349d72b3a7198358cd640c678802.patch";
        hash = "sha256-2YROkQ92jGOJZr+4+LrwRJKxhA39Bypb1xFdo6aftu8=";
      })
    ];

    postPatch = ''
      # Comment out the iCTS test cases that will fail due to some linking issues on aarch64-linux
      sed -i '17,28s/^/# /' src/operation/iCTS/test/CMakeLists.txt
    '';

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
  version = "0-unstable-2025-05-30";

  src = rootSrc;

  nativeBuildInputs = [
    cmake
    ninja
    flex
    bison
    python3
    tcl
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
    gtest
    glog-lock
    gflags
    boost
    onnxruntime
    eigen
    yaml-cpp
    libunwind
    metis
    gmp
    tcl
    zlib
  ];

  postInstall = ''
    # Tests rely on hardcoded path, so they should not be included
    rm $out/bin/*test $out/bin/*Test $out/bin/test_* $out/bin/*_app

    # Copy scripts to the share directory for the test
    mkdir -p $out/share/scripts
    cp -r $src/scripts/hello.tcl $out/share/scripts/
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    # Run the tests
    $out/bin/iEDA -script $out/share/scripts/hello.tcl

    runHook postInstallCheck
  '';

  doInstallCheck = true;

  enableParallelBuild = true;

  meta = {
    description = "Open-source EDA infracstructure and tools from Netlist to GDS for ASIC design";
    homepage = "https://gitee.com/oscc-project/iEDA";
    license = lib.licenses.mulan-psl2;
    maintainers = with lib.maintainers; [
      xinyangli
      Emin017
    ];
    mainProgram = "iEDA";
    platforms = lib.platforms.linux;
  };
}
