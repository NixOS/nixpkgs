{
  lib,
  fetchurl,
  fetchpatch,
  cmake,
  unzip,
  makeWrapper,
  boost183,
  llvmPackages,
  gmp,
  emacs-nox,
  jre8_headless,
  tcl,
  tk,
}:

let
  stdenv = llvmPackages.stdenv;

  # This is a workaround to avoid using sbt.
  # I guess it is acceptable to fetch the bootstrapping compiler in binary form.
  bootcompiler = fetchurl {
    url = "https://github.com/layus/mozart2/releases/download/v2.0.0-beta.1/bootcompiler.jar";
    hash = "sha256-X8Lby0vhsFO0IWZw2r5aXFRRWCaMaBXQMfn9B5EK8ME=";
  };
  emacs = emacs-nox;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mozart2";
  version = "2.0.1";

  src = fetchurl {
    url = "https://github.com/mozart/mozart2/releases/download/v${finalAttrs.version}/mozart2-${finalAttrs.version}-Source.zip";
    hash = "sha256-lLYEC+SvSGbMqkIDFOCzG5g0XKy0gNXYQT3+78tPTdU=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  patches = [
    ./patch-limits.diff
    (fetchpatch {
      name = "remove-uses-of-deprecated-boost-apis.patch";
      url = "https://github.com/mozart/mozart2/commit/4256d3a9122e1cbb01400a1807bdee66088ff274.patch";
      hash = "sha256-AnOrBnxoCxqis+RdCsq8EKBg//jcNHSOFYUvf7vh+Hc=";
    })
  ];

  postConfigure = ''
    cp ${bootcompiler} bootcompiler/bootcompiler.jar
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    unzip
    jre8_headless
  ];

  cmakeFlags = [
    "-DBoost_USE_STATIC_LIBS=OFF"
    "-DMOZART_BOOST_USE_STATIC_LIBS=OFF"
    # We are building with clang, as nix does not support having clang and
    # gcc together as compilers and we need clang for the sources generation.
    # However, clang emits tons of warnings about gcc's atomic-base library.
    "-DCMAKE_CXX_FLAGS=-Wno-braced-scalar-init"
  ];

  fixupPhase = ''
    wrapProgram $out/bin/oz --set OZEMACS ${emacs}/bin/emacs
  '';

  buildInputs = [
    boost183
    gmp
    emacs
    tcl
    tk
  ];

  postPatch = ''
    substituteInPlace {vm,.}/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace vm/vm/test/gtest/{googletest,.}/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6.4)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace bootcompiler/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace {boosthost,opi,wish,stdlib}/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.6)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "Open source implementation of Oz 3";
    maintainers = with lib.maintainers; [
      layus
      h7x4
    ];
    license = lib.licenses.bsd2;
    homepage = "https://mozart.github.io";
    platforms = lib.platforms.all;
    # Trace/BPT trap: 5
    broken = stdenv.hostPlatform.isDarwin;
  };

})
