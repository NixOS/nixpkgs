{ stdenv
, fetchgit
, cmake
, boost
, gmp
, jsoncpp
, leveldb
, cryptopp
, libcpuid
, miniupnpc
, libjson_rpc_cpp
, curl
, libmicrohttpd
, mesa

, opencl-headers ? null

, withAMD ? false
, amdappsdk ? null

, withBeignet ? false
, beignet ? null

, withCUDA ? false
, nvidia_x11 ? null

, withGUI ? false
, qtwebengine ? null
, qtbase ? null
, qtdeclarative ? null

, withProfiling ? false
, gperftools ? null

, withEVMJIT ? false
, llvm ? null
, zlib ? null
, ncurses ? null

, extraCmakeFlags ? []
}:

assert withAMD -> (amdappsdk != null);
assert withBeignet -> (beignet != null);
assert withCUDA -> (nvidia_x11 != null);
assert stdenv.lib.findSingle (x: x) true false [ withAMD withBeignet withCUDA ];

assert withGUI -> (qtwebengine != null) && (qtbase != null) && (qtdeclarative != null);
assert withProfiling -> (gperftools != null);
assert withEVMJIT -> (llvm != null) && (zlib != null) && (ncurses != null);

let
  withOpenCL = (stdenv.lib.any (x: x) [ withAMD withBeignet withCUDA ]);
in

assert withOpenCL -> (opencl-headers != null);

stdenv.mkDerivation rec {
  name = "cpp-ethereum-${version}";
  version = "1.2.9";

  src = fetchgit {
    url = https://github.com/ethereum/webthree-umbrella.git;
    rev = "850479b159a0bfa316fd261ab96b0a043acd766c";
    sha256 = "0k8w8gqzy71x77p0p85r38gfdnzrlzk2yvb3ablml9ppg4qb4ch5";
  };

  patchPhase = stdenv.lib.optional withBeignet ''
    sed -i -re 's#NAMES\ (OpenCL.*)#NAMES\ libcl.so\ \1#g' webthree-helpers/cmake/FindOpenCL.cmake
  '';

  cmakeFlags = with stdenv.lib; concatStringsSep " " (flatten [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DGUI=${toString withGUI}"
    "-DETHASHCL=${toString withOpenCL}"
    "-DPROFILING=${toString withProfiling}"
    "-DEVMJIT=${toString withEVMJIT}"
    (optional withOpenCL "-DCMAKE_INCLUDE_PATH=${opencl-headers}/include")
    (optional withAMD "-DCMAKE_LIBRARY_PATH=${amdappsdk}/lib")
    (optional withBeignet "-DCMAKE_LIBRARY_PATH=${beignet}/lib/beignet")
    (optional withCUDA "-DCMAKE_LIBRARY_PATH=${nvidia_x11}/lib")
    (optional withEVMJIT "-DCMAKE_PREFIX_PATH=${llvm}")
    extraCmakeFlags
  ]);

  configurePhase = ''
    export BOOST_INCLUDEDIR=${boost}/include
    export BOOST_LIBRARYDIR=${boost.out}/lib

    mkdir -p Build/Install
    pushd Build

    cmake .. -DCMAKE_INSTALL_PREFIX=$(pwd)/Install $cmakeFlags
  '';

  buildInputs = with stdenv.lib; [
    cmake
    boost
    gmp
    jsoncpp
    leveldb
    cryptopp
    libcpuid
    miniupnpc
    libjson_rpc_cpp
    curl
    libmicrohttpd
    mesa
    (optional withOpenCL opencl-headers)
    (optional withAMD amdappsdk)
    (optional withBeignet beignet)
    (optional withCUDA nvidia_x11)
    (optional withGUI [
      qtwebengine
      qtbase
      qtdeclarative
    ])
    (optional withProfiling gperftools)
    (optional withEVMJIT [
      llvm
      zlib
      ncurses
    ])
  ];

  runPath = with stdenv.lib; concatStringsSep ":" (flatten [
    (makeLibraryPath (flatten [ stdenv.cc.cc buildInputs ]))
    (optional withBeignet "${beignet}/lib/beignet")
  ]);

  installPhase = ''
    make install

    mkdir -p $out

    for f in Install/lib/*.so* $(find Install/bin -executable -type f); do
      patchelf --set-rpath $runPath:$out/lib $f
    done

    cp -r Install/* $out
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    decription = "Umbrella project for the Ethereum C++ implementation";
    homepage = https://github.com/ethereum/webthree-umbrella.git;
    license = licenses.gpl3;
    maintainers = with maintainers; [ artuuge ];
    platforms = platforms.linux;
  };
}
