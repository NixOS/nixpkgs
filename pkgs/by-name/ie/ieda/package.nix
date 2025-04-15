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
    version = "2025-03-12";
    src = fetchgit {
      url = "https://gitee.com/oscc-project/iEDA";
      rev = "3a066726aa9521991a46d603f041831361d3ba51";
      sha256 = "sha256-iPdp1xEje8bBumI/eqhvw0llg3NAzRb8pzc3fmWMwtU=";
    };

    patches = [
      # This patch is to fix the build error caused by the missing of the header file,
      # and remove some libs or path that they hard-coded in the source code.
      # Should be removed after we upstream these changes.
      (fetchpatch {
        url = "https://github.com/Emin017/iEDA/commit/0eb86754063df6e21b35fd1396363ebc75b760c5.patch";
        hash = "sha256-hdH6+g3eZUxDudWqTwbaWNKS0fwfUWJPp//dqGNJQfM=";
      })
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
  version = "0-unstable-2025-03-12";

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
  '';

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
