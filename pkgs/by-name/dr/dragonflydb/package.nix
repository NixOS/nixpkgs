{
  fetchFromGitHub,
  lib,
  stdenv,

  # Dependencies
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
  liburing,
  lz4,
  pcre2,
  pugixml,
  rapidjson,
  re2,
  re-flex,
  uni-algo,
  xxhash,
  zstd,

  # Build tools
  autoconf,
  autoconf-archive,
  automake116x,
  bison,
  cmake,
  gcc-unwrapped,
  ninja,
  perl,

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
  version = "1.39.0";

  src = fetchFromGitHub {
    owner = "dragonflydb";
    repo = "dragonfly";
    tag = "v${version}";
    hash = "sha256-vLuuf3fVdVzcd06bafGiLtION6IwTnspiIJmZF9tUGg=";
    fetchSubmodules = true;
  };

  # dragonfly's helio applies patches written against this exact abseil
  # release (see helio/patches/abseil-20250512.1.patch), so it's pinned here
  # rather than taken from nixpkgs' abseil-cpp, which tracks a newer version.
  abseil-cpp-20250512 = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    tag = "20250512.1";
    hash = "sha256-eB7OqTO9Vwts9nYQ/Mdq0Ds4T1KgmmpYdzU09VPWOhk=";
  };

  aws-sdk-cpp-1-11-717 = fetchFromGitHub {
    owner = "aws";
    repo = "aws-sdk-cpp";
    tag = "1.11.717";
    hash = "sha256-stDZg9dvKljnbZZUHEn1KmlgDdvW6BK7H7RtGk/nyEI=";
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
    rev = "Dragonfly1.5.0";
    hash = "sha256-9W9GJpzKuqolXoz5iYiE1EbVWr7HiFqpMgZO1BQdi0s=";
  };

  # dragonfly's search module uses a fork of hnswlib with custom changes, so
  # this can't come from nixpkgs' hnswlib (nmslib upstream).
  hnswlib-dragonfly = fetchFromGitHub {
    owner = "dragonflydb";
    repo = "hnswlib";
    rev = "d07dd1da2bf48b85d2f03b8396193ad7120f75c2";
    hash = "sha256-GFBjKzDauznGGfkXZqSFgbvBKxDXbx2rETqY5BnCIiw=";
  };

  lua-dragonfly = fetchFromGitHub {
    owner = "dragonflydb";
    repo = "lua";
    rev = "Dragonfly-5.4.6a";
    hash = "sha256-uLNe+hLihu4wMW/wstGnYdPa2bGPC5UiNE+VyNIYY2c=";
  };

  mimalloc224 = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    tag = "v2.2.4";
    hash = "sha256-+8xZT+mVEqlqabQc+1buVH/X6FZxvCd0rWMyjPu9i4o=";
  };

  # nixpkgs' libstemmer is older than the snowball release dragonfly's search
  # module builds against, so the source is pinned and built in-tree here.
  snowball-stemmer = fetchFromGitHub {
    owner = "snowballstem";
    repo = "snowball";
    tag = "v3.0.1";
    hash = "sha256-QPIPePddUqwpa0YMn0E7H9GZj3s2bEkJzZdXlrHeZbo=";
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
    cp -r --no-preserve=mode,ownership ${abseil-cpp-20250512} build/_deps/abseil_cpp-src
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
    cp -r --no-preserve=mode,ownership ${jsoncons-dragonfly} build/deps-nixpkgs/jsoncons
    cp -r --no-preserve=mode,ownership ${liburing.src} build/deps-nixpkgs/uring
    cp -r --no-preserve=mode,ownership ${lua-dragonfly} build/deps-nixpkgs/lua
    cp -r --no-preserve=mode,ownership ${lz4.src} build/deps-nixpkgs/lz4
    cp -r --no-preserve=mode,ownership ${mimalloc224} build/deps-nixpkgs/mimalloc224
    cp -r --no-preserve=mode,ownership ${rapidjson.src} build/deps-nixpkgs/rapidjson
    cp -r --no-preserve=mode,ownership ${pugixml.src} build/deps-nixpkgs/pugixml
    cp -r --no-preserve=mode,ownership ${re-flex.src} build/deps-nixpkgs/reflex
    cp -r --no-preserve=mode,ownership ${xxhash.src} build/deps-nixpkgs/xxhash
    cp -r --no-preserve=mode,ownership ${zstd.src} build/deps-nixpkgs/zstd

    # c-ares is provided as a tarball, extract it
    mkdir -p build/deps-nixpkgs/cares
    tar -xzf ${c-ares.src} -C build/deps-nixpkgs/cares --strip-components=1

    ${
      if withAws then
        ''
          cp -r --no-preserve=mode,ownership ${aws-sdk-cpp-1-11-717} build/deps-nixpkgs/aws-sdk-cpp
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
          cp -r --no-preserve=mode,ownership ${hnswlib-dragonfly} build/deps-nixpkgs/hnswlib
          cp -r --no-preserve=mode,ownership ${snowball-stemmer} build/deps-nixpkgs/stemmer
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

    # snowball generates its C sources with perl scripts run via their shebang;
    # the source copy drops their execute bit, so restore it and fix the
    # /usr/bin/env shebang for the sandbox.
    if [ -d build/deps-nixpkgs/stemmer ]; then
      find build/deps-nixpkgs/stemmer -name '*.pl' -exec chmod +x {} +
      patchShebangs build/deps-nixpkgs/stemmer
    fi
  '';

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake116x
    bison
    cmake
    ninja
    perl
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

  meta = {
    description = "Modern replacement for Redis and Memcached";
    homepage = "https://dragonflydb.io/";
    license = lib.licenses.bsl11;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      typedrat
      yureien
    ];
  };
}
