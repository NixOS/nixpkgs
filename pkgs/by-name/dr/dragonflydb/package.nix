{
  fetchFromGitHub,
  lib,
  stdenv,

  # Dependencies
  abseil-cpp,
  c-ares,
  croncpp,
  double-conversion,
  expected-lite,
  fast-float,
  flatbuffers_23,
  gbenchmark,
  gperftools,
  gtest,
  hdrhistogram_c,
  hnswlib,
  jemalloc,
  liburing,
  lz4,
  pcre2,
  pugixml,
  rapidjson,
  re2,
  re-flex,
  uni-algo,
  xxHash,
  zstd,

  # Build tools
  autoconf,
  autoconf-archive,
  automake116x,
  bison,
  cmake,
  gcc-unwrapped,
  ninja,

  # Runtime dependencies
  boost,
  libtool,
  libunwind,
  openssl,
  zlib,

  # Options
  withAws ? true,
  withGcp ? true,
  withGperf ? true,
  withPcre ? true,
  withRe2 ? true,
  withSearch ? true,
  withAsan ? false,
  withUsan ? false,
}:

let
  pname = "dragonflydb";
  version = "1.34.2";

  src = fetchFromGitHub {
    owner = "dragonflydb";
    repo = "dragonfly";
    tag = "v${version}";
    hash = "sha256-n70IB32tZDe665hVLrKC0BSSJutmYhtPJvfNa48xaqA=";
    fetchSubmodules = true;
  };

  aws-sdk-cpp-1-11-162 = fetchFromGitHub {
    owner = "aws";
    repo = "aws-sdk-cpp";
    tag = "1.11.162";
    hash = "sha256-NxVE7H8BOetpbBkB2PTVBoHSXYm6cTp41F1LJmhtBbs=";
    fetchSubmodules = true;
  };

  glog-absl = fetchFromGitHub {
    owner = "romange";
    repo = "glog";
    rev = "Absl";
    hash = "sha256-68Hx3kIPgyMSdHCUpYr68Cw8V4Umtyd+4VLZc3zUb1s=";
  };

  jsoncons-dragonfly = fetchFromGitHub {
    owner = "dragonflydb";
    repo = "jsoncons";
    rev = "Dragonfly.178";
    hash = "sha256-cxM95DFFo5z+eImgZzJw+ykaeSDtBF+hw5qo6gnL53s=";
  };

  lua-dragonfly = fetchFromGitHub {
    owner = "dragonflydb";
    repo = "lua";
    rev = "Dragonfly-5.4.6a";
    hash = "sha256-uLNe+hLihu4wMW/wstGnYdPa2bGPC5UiNE+VyNIYY2c=";
  };

  mimalloc216 = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    tag = "v2.1.6";
    hash = "sha256-Ff3+RP+lAXCOeHJ87oG3c02rPP4WQIbg5L/CVe6gA3M=";
  };

  mimalloc224 = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    tag = "v2.2.4";
    hash = "sha256-+8xZT+mVEqlqabQc+1buVH/X6FZxvCd0rWMyjPu9i4o=";
  };

  withUnwind = !stdenv.targetPlatform.isAarch64;
in
stdenv.mkDerivation {
  inherit pname version src;

  patches = [
    ./external-libs.patch
    ./helio-third-party.patch
  ];

  postPatch = ''
    chmod +x helio/blaze.sh
  '';

  preConfigure = ''
    # Create directory for nixpkgs dependencies
    mkdir -p build/_deps build/deps-nixpkgs

    # Copy FetchContent dependencies (in helio/cmake/third_party.cmake)
    # These go to build/_deps/ where FetchContent expects them
    cp -r --no-preserve=mode,ownership ${abseil-cpp.src} build/_deps/abseil_cpp-src
    cp -r --no-preserve=mode,ownership ${gbenchmark.src} build/_deps/benchmark-src
    cp -r --no-preserve=mode,ownership ${glog-absl} build/_deps/glog-src
    cp -r --no-preserve=mode,ownership ${gtest.src} build/_deps/gtest-src

    # Copy add_third_party dependencies to deps-nixpkgs
    cp -r --no-preserve=mode,ownership ${croncpp.src} build/deps-nixpkgs/croncpp
    cp -r --no-preserve=mode,ownership ${double-conversion.src} build/deps-nixpkgs/dconv
    cp -r --no-preserve=mode,ownership ${expected-lite.src} build/deps-nixpkgs/expected
    cp -r --no-preserve=mode,ownership ${fast-float.src} build/deps-nixpkgs/fast_float
    cp -r --no-preserve=mode,ownership ${flatbuffers_23.src} build/deps-nixpkgs/flatbuffers
    cp -r --no-preserve=mode,ownership ${hdrhistogram_c.src} build/deps-nixpkgs/hdr_histogram
    cp -r --no-preserve=mode,ownership ${jemalloc.src} build/deps-nixpkgs/jemalloc
    cp -r --no-preserve=mode,ownership ${jsoncons-dragonfly} build/deps-nixpkgs/jsoncons
    cp -r --no-preserve=mode,ownership ${liburing.src} build/deps-nixpkgs/uring
    cp -r --no-preserve=mode,ownership ${lua-dragonfly} build/deps-nixpkgs/lua
    cp -r --no-preserve=mode,ownership ${lz4.src} build/deps-nixpkgs/lz4
    cp -r --no-preserve=mode,ownership ${mimalloc216} build/deps-nixpkgs/mimalloc216
    cp -r --no-preserve=mode,ownership ${mimalloc224} build/deps-nixpkgs/mimalloc224
    cp -r --no-preserve=mode,ownership ${pugixml.src} build/deps-nixpkgs/pugixml
    cp -r --no-preserve=mode,ownership ${re-flex.src} build/deps-nixpkgs/reflex
    cp -r --no-preserve=mode,ownership ${xxHash.src} build/deps-nixpkgs/xxhash
    cp -r --no-preserve=mode,ownership ${zstd.src} build/deps-nixpkgs/zstd

    # c-ares is provided as a tarball, extract it
    mkdir -p build/deps-nixpkgs/cares
    tar -xzf ${c-ares.src} -C build/deps-nixpkgs/cares --strip-components=1

    ${
      if withAws then
        ''
          cp -r --no-preserve=mode,ownership ${aws-sdk-cpp-1-11-162} build/deps-nixpkgs/aws-sdk-cpp
        ''
      else
        ""
    }

    ${
      if withGcp then
        ''
          cp -r --no-preserve=mode,ownership ${rapidjson.src} build/deps-nixpkgs/rapidjson
        ''
      else
        ""
    }

    ${
      if withGperf then
        ''
          cp -r --no-preserve=mode,ownership ${gperftools.src} build/deps-nixpkgs/gperf
        ''
      else
        ""
    }

    ${
      if withSearch then
        ''
          cp -r --no-preserve=mode,ownership ${hnswlib.src} build/deps-nixpkgs/hnswlib
          cp -r --no-preserve=mode,ownership ${uni-algo.src} build/deps-nixpkgs/uni-algo
        ''
      else
        ""
    }

    # Fix permissions
    chmod -R u+w build/deps-nixpkgs build/_deps
    chmod u+x build/deps-nixpkgs/reflex/configure
    chmod u+x build/deps-nixpkgs/uring/configure
    touch build/deps-nixpkgs/xxhash/xxhsum.1
  '';

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake116x
    bison
    cmake
    ninja
  ];

  buildInputs = [
    boost
    libtool
    openssl
    zlib
  ]
  ++ lib.optional withPcre pcre2
  ++ lib.optional withRe2 re2
  ++ lib.optional withUnwind libunwind;

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_AR" "${gcc-unwrapped}/bin/gcc-ar")
    (lib.cmakeFeature "CMAKE_RANLIB" "${gcc-unwrapped}/bin/gcc-ranlib")
    (lib.cmakeBool "ENABLE_GIT_VERSION" false)
    (lib.cmakeBool "WITH_ASAN" withAsan)
    (lib.cmakeBool "WITH_AWS" withAws)
    (lib.cmakeBool "WITH_GCP" withGcp)
    (lib.cmakeBool "WITH_GPERF" withGperf)
    (lib.cmakeBool "WITH_SEARCH" withSearch)
    (lib.cmakeBool "WITH_USAN" withUsan)
  ];

  ninjaFlags = [ "dragonfly" ];

  # dragonflydb's tests rely heavily on outdated Python packages we don't
  # have in nixpkgs, and it would be a highly non-trivial endeavor to
  # recreate all of them locally to get them to run properly.
  doCheck = false;

  dontUseNinjaInstall = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 ./dragonfly $out/bin/dragonfly

    runHook postInstall
  '';

  meta = with lib; {
    description = "Modern replacement for Redis and Memcached";
    homepage = "https://dragonflydb.io/";
    license = licenses.bsl11;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      typedrat
      yureien
    ];
  };
}
