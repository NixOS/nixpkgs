{
  lib,
  stdenv,
  fetchFromGitHub,
  abseil-cpp,
  autoconf,
  autoconf-archive,
  automake,
  bison,
  boost,
  c-ares,
  cmake,
  double-conversion,
  expected-lite,
  flatbuffers_23,
  gbenchmark,
  gperftools,
  gtest,
  hdrhistogram_c,
  hnswlib,
  libtool,
  libunwind,
  liburing,
  libxml2,
  lz4,
  ninja,
  openssl,
  pugixml,
  rapidjson,
  readline,
  re-flex,
  xxHash,
  zlib,
  zstd,
}:

let
  pname = "dragonflydb";
  version = "1.34.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = "dragonfly";
    tag = "v${version}";
    hash = "sha256-n70IB32tZDe665hVLrKC0BSSJutmYhtPJvfNa48xaqA=";
    fetchSubmodules = true;
  };

  aws-sdk-cpp = fetchFromGitHub {
    owner = "aws";
    repo = "aws-sdk-cpp";
    rev = "3e51fa016655eeb6b6610bdf8fe7cf33ebbf3e00";
    hash = "sha256-NxVE7H8BOetpbBkB2PTVBoHSXYm6cTp41F1LJmhtBbs=";
    fetchSubmodules = true;
  };

  croncpp = fetchFromGitHub {
    owner = "mariusbancila";
    repo = "croncpp";
    tag = "v2023.03.30";
    hash = "sha256-SBjNzy54OGEMemBp+c1gaH90Dc7ySL915z4E64cBWTI=";
  };

  fast_float = fetchFromGitHub {
    owner = "fastfloat";
    repo = "fast_float";
    tag = "v5.2.0";
    hash = "sha256-lirrk2J8XkGkazsnExEW7bKwz2GtYiyZ3VZEprevs1w=";
  };

  glog = fetchFromGitHub {
    owner = "romange";
    repo = "glog";
    rev = "a73c809385d17c37030838fe529a9f0713490502";
    hash = "sha256-68Hx3kIPgyMSdHCUpYr68Cw8V4Umtyd+4VLZc3zUb1s=";
  };

  jsoncons = fetchFromGitHub {
    owner = "dragonflydb";
    repo = "jsoncons";
    rev = "990b0a2077a50a62a486eac2647f0411e65b3bbe";
    hash = "sha256-cxM95DFFo5z+eImgZzJw+ykaeSDtBF+hw5qo6gnL53s=";
  };

  lua = fetchFromGitHub {
    owner = "lua";
    repo = "lua";
    rev = "6baee9ef9d5657ab582c8a4b9f885ec58ed502d0";
    hash = "sha256-PhQxjhzwfinJT7Bd6EwN98Jl/F0CfXOmB4nL7WRRDp8=";
  };

  mimalloc = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    tag = "v2.1.6";
    hash = "sha256-Ff3+RP+lAXCOeHJ87oG3c02rPP4WQIbg5L/CVe6gA3M=";
  };

  mimalloc2 = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    tag = "v2.2.4";
    hash = "sha256-+8xZT+mVEqlqabQc+1buVH/X6FZxvCd0rWMyjPu9i4o=";
  };

  uni-algo = fetchFromGitHub {
    owner = "uni-algo";
    repo = "uni-algo";
    tag = "v1.0.0";
    hash = "sha256-0yoreY0ckgvHbXHw35ZLOxr4gPCWdZtK8ydl5voeEoQ=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  prePatch = ''
    mkdir -p ./build/{third_party,_deps} ./build/third_party/cares

    ln -s ${croncpp} ./build/third_party/croncpp
    ln -s ${expected-lite.src} ./build/third_party/expected
    ln -s ${fast_float} ./build/third_party/fast_float
    ln -s ${flatbuffers_23.src} ./build/third_party/flatbuffers
    ln -s ${gbenchmark.src} ./build/_deps/benchmark-src
    ln -s ${glog} ./build/_deps/glog-src
    ln -s ${gtest.src} ./build/_deps/gtest-src
    ln -s ${hdrhistogram_c.src} ./build/third_party/hdr_histogram
    ln -s ${hnswlib.src} ./build/third_party/hnswlib
    ln -s ${jsoncons} ./build/third_party/jsoncons
    ln -s ${pugixml.src} ./build/third_party/pugixml
    ln -s ${rapidjson.src} ./build/third_party/rapidjson
    ln -s ${uni-algo} ./build/third_party/uni-algo
    ln -s ${zstd.src} ./build/third_party/zstd

    tar xvf ${c-ares.src} --strip-components=1 -C ./build/third_party/cares

    cp -R --no-preserve=mode,ownership ${aws-sdk-cpp} ./build/third_party/aws
    cp -R --no-preserve=mode,ownership ${double-conversion.src} ./build/third_party/dconv
    cp -R --no-preserve=mode,ownership ${gperftools.src} ./build/third_party/gperf
    cp -R --no-preserve=mode,ownership ${liburing.src} ./build/third_party/uring
    cp -R --no-preserve=mode,ownership ${lua} ./build/third_party/lua
    cp -R --no-preserve=mode,ownership ${lz4.src} ./build/third_party/lz4
    cp -R --no-preserve=mode,ownership ${mimalloc2} ./build/third_party/mimalloc2
    cp -R --no-preserve=mode,ownership ${mimalloc} ./build/third_party/mimalloc
    cp -R --no-preserve=mode,ownership ${re-flex.src} ./build/third_party/reflex
    cp -R --no-preserve=mode,ownership ${xxHash.src} ./build/third_party/xxhash

    chmod u+x ./build/third_party/uring/configure
    cp ./build/third_party/xxhash/cli/xxhsum.{1,c} ./build/third_party/xxhash
  '';

  patches = [
    ./0001-Patch-cmake-files-to-not-download.patch
    ./0002-cmake-4-fix-for-dconv.patch
    ./0003-Patch-cmake-file-to-not-download-in-helio.patch
  ];

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake
    bison
    cmake
    ninja
    readline
    re-flex
  ];

  buildInputs = [
    abseil-cpp
    boost
    libtool
    libunwind
    libxml2
    openssl
    zlib
    zstd
  ];

  ninjaFlags = [ "dragonfly" ];

  doCheck = false; # Impractical to get the test dependencies working/tests compiling.
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
