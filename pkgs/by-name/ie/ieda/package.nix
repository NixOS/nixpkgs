{
  lib,
  stdenv,
  fetchgit,
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
  pkg-config,
  curl,
  onetbb,
}:
let
  rootSrc = stdenv.mkDerivation {
    pname = "iEDA-src";
    version = "2025-12-16";
    src = fetchgit {
      url = "https://gitee.com/oscc-project/iEDA";
      rev = "b73be0f1909294b56b2dbb27dba04b6cd9e0070d";
      sha256 = "sha256-bvSHfQXDk7caTELtjgpSZhJdYfRzfk9VmFm2iBW2lRw=";
    };

    patches = [
      # This patch is to fix the build system to properly find and link against rust libraries.
      # Due to the way they organized the source code, it's hard to upstream this patch.
      # So we have to maintain this patch locally.
      (fetchpatch {
        url = "https://github.com/Emin017/iEDA/commit/e5f3ce024965df5e1d400b6a1d7f8b5b307a4bf3.patch";
        hash = "sha256-YJnY+r9A887WT0a/H/Zf++r1PpD7t567NpkesDmIsD0=";
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
  version = "0.1.0-unstable-2025-12-16";

  src = rootSrc;

  nativeBuildInputs = [
    cmake
    ninja
    flex
    bison
    python3
    tcl
    pkg-config
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
    glog
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
    curl
    onetbb
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

  doInstallCheck = !stdenv.hostPlatform.isAarch64; # Tests will fail on aarch64-linux, wait for upstream fix: https://github.com/microsoft/onnxruntime/issues/10038

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
