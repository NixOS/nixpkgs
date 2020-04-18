{ stdenv
, fetchFromGitHub
, cmake
, jsoncpp
, libjson-rpc-cpp
, curl
, boost
, leveldb
, cryptopp
, libcpuid
, opencl-headers
, ocl-icd
, miniupnpc
, libmicrohttpd
, gmp
, libGLU, libGL
, extraCmakeFlags ? []
}:
stdenv.mkDerivation rec {
  pname = "cpp-ethereum";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "cpp-ethereum";
    rev = "62ab9522e58df9f28d2168ea27999a214b16ea96";
    sha256 = "1fxgpqhmjhpv0zzs1m3yf9h8mh25dqpa7pmcfy7f9qiqpfdr4zq9";
  };

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" extraCmakeFlags ];

  configurePhase = ''
    export BOOST_INCLUDEDIR=${boost.dev}/include
    export BOOST_LIBRARYDIR=${boost.out}/lib

    mkdir -p Build/Install
    pushd Build

    cmake .. -DCMAKE_INSTALL_PREFIX=$(pwd)/Install $cmakeFlags
  '';

  enableParallelBuilding = true;

  runPath = with stdenv.lib; makeLibraryPath ([ stdenv.cc.cc ] ++ buildInputs);

  installPhase = ''
    make install

    mkdir -p $out

    for f in Install/lib/*.so* $(find Install/bin -executable -type f); do
      patchelf --set-rpath $runPath:$out/lib $f
    done

    cp -r Install/* $out
  '';

  buildInputs = [
    cmake
    jsoncpp
    libjson-rpc-cpp
    curl
    boost
    leveldb
    cryptopp
    libcpuid
    opencl-headers
    ocl-icd
    miniupnpc
    libmicrohttpd
    gmp
    libGLU libGL
  ];

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Ethereum C++ client";
    homepage = "https://github.com/ethereum/cpp-ethereum";
    license = licenses.gpl3;
    maintainers = with maintainers; [ artuuge ];
    platforms = platforms.linux;
    broken = true; # 2018-04-10
  };
}
