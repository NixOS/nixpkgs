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

, withOpenCL ? false
, opencl-headers ? null
, ocl-icd ? null

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

assert withOpenCL -> (opencl-headers != null) && (ocl-icd != null);
assert withGUI -> (qtwebengine != null) && (qtbase != null) && (qtdeclarative != null);
assert withProfiling -> (gperftools != null);
assert withEVMJIT -> (llvm != null) && (zlib != null) && (ncurses != null);

stdenv.mkDerivation rec {
  name = "cpp-ethereum-${version}";
  version = "1.2.9";

  src = fetchgit {
    url = https://github.com/ethereum/webthree-umbrella.git;
    rev = "850479b159a0bfa316fd261ab96b0a043acd766c";
    sha256 = "0k8w8gqzy71x77p0p85r38gfdnzrlzk2yvb3ablml9ppg4qb4ch5";
  };

  cmakeFlags = with stdenv.lib; concatStringsSep " " (flatten [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DGUI=${toString withGUI}"
    "-DETHASHCL=${toString withOpenCL}"
    "-DPROFILING=${toString withProfiling}"
    "-DEVMJIT=${toString withEVMJIT}"
    (optional withOpenCL [
      "-DCMAKE_INCLUDE_PATH=${opencl-headers}/include"
      "-DCMAKE_LIBRARY_PATH=${ocl-icd}/lib"
    ])
    (optional withEVMJIT "-DCMAKE_PREFIX_PATH=${llvm}")
    extraCmakeFlags
  ]);

  configurePhase = ''
    export BOOST_INCLUDEDIR=${boost.dev}/include
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
    (optional withOpenCL [
      opencl-headers
      ocl-icd
    ])
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

  runPath = with stdenv.lib; (makeLibraryPath (flatten [ stdenv.cc.cc buildInputs ]));

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
