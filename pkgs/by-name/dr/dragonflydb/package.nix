{ fetchFromGitHub
, fetchurl
, lib
, stdenv
, double-conversion
, gperftools
, mimalloc
, rapidjson
, liburing
, xxHash
, gbenchmark
, glog
, gtest
, jemalloc
, gcc-unwrapped
, autoconf
, autoconf-archive
, automake
, cmake
, ninja
, boost
, libunwind
, libtool
, openssl
}:

let
  pname = "dragonflydb";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "dragonfly";
    rev = "v${version}";
    hash = "sha256-P6WMW/n+VezWDXGagT4B+ZYyCp8oufDV6MTrpKpLZcs=";
    fetchSubmodules = true;
  };

  # Needed exactly 5.4.4 for patch to work
  lua = fetchurl {
    url = "https://github.com/lua/lua/archive/refs/tags/v5.4.4.tar.gz";
    hash = "sha256-L/ibvqIqfIuRDWsAb1ukVZ7c9GiiVTfO35mI7ZD2tFA=";
  };

  # Needed exactly 20211102.0 for patch to work
  abseil-cpp_202111 = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "20211102.0";
    sha256 = "sha256-sSXT6D4JSrk3dA7kVaxfKkzOMBpqXQb0WbMYWG+nGwk=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  postPatch = ''
    mkdir -p ./build/{third_party,_deps}
    ln -s ${double-conversion.src} ./build/third_party/dconv
    ln -s ${mimalloc.src} ./build/third_party/mimalloc
    ln -s ${rapidjson.src} ./build/third_party/rapidjson
    ln -s ${gbenchmark.src} ./build/_deps/benchmark-src
    ln -s ${gtest.src} ./build/_deps/gtest-src
    cp -R --no-preserve=mode,ownership ${gperftools.src} ./build/third_party/gperf
    cp -R --no-preserve=mode,ownership ${liburing.src} ./build/third_party/uring
    cp -R --no-preserve=mode,ownership ${xxHash.src} ./build/third_party/xxhash
    cp -R --no-preserve=mode,ownership ${abseil-cpp_202111} ./build/_deps/abseil_cpp-src
    cp -R --no-preserve=mode,ownership ${glog.src} ./build/_deps/glog-src
    chmod u+x ./build/third_party/uring/configure
    cp ./build/third_party/xxhash/cli/xxhsum.{1,c} ./build/third_party/xxhash
    patch -p1 -d ./build/_deps/glog-src < ${./glog.patch}
    sed '
    s@REPLACEJEMALLOCURL@file://${jemalloc.src}@
    s@REPLACELUAURL@file://${lua}@
    ' ${./fixes.patch} | patch -p1
  '';

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake
    cmake
    ninja
  ];

  buildInputs = [
    boost
    libunwind
    libtool
    openssl
  ];

  cmakeFlags = [
    "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
  ];

  ninjaFlags = [ "dragonfly" ];

  doCheck = false;
  dontUseNinjaInstall = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ./dragonfly $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Modern replacement for Redis and Memcached";
    homepage = "https://dragonflydb.io/";
    license = licenses.bsl11;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yureien ];
  };
}
