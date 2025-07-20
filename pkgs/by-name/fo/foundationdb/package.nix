{
  stdenv,
  fetchFromGitHub,
  lib,
  fetchpatch,
  cmake,
  ninja,
  python3,
  openjdk,
  mono,
  openssl,
  boost186,
  pkg-config,
  msgpack-cxx,
  toml11,
  jemalloc,
  doctest,
}:
let
  boost = boost186;
  # Only even numbered versions compile on aarch64; odd numbered versions have avx enabled.
  avxEnabled =
    version:
    let
      isOdd = n: lib.trivial.mod n 2 != 0;
      patch = lib.toInt (lib.versions.patch version);
    in
    isOdd patch;
in
stdenv.mkDerivation rec {
  name = "foundationdb";
  version = "7.3.42";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "foundationdb";
    tag = version;
    hash = "sha256-jQcm+HLai5da2pZZ7iLdN6fpQZxf5+/kkfv9OSXQ57c=";
  };

  patches = [
    ./disable-flowbench.patch
    ./don-t-use-static-boost-libs.patch
    # GetMsgpack: add 4+ versions of upstream
    # https://github.com/apple/foundationdb/pull/10935
    (fetchpatch {
      url = "https://github.com/apple/foundationdb/commit/c35a23d3f6b65698c3b888d76de2d93a725bff9c.patch";
      hash = "sha256-bneRoZvCzJp0Hp/G0SzAyUyuDrWErSpzv+ickZQJR5w=";
    })
    # Add a dependency that prevents bindingtester to run before the python bindings are generated
    # https://github.com/apple/foundationdb/pull/11859
    (fetchpatch {
      url = "https://github.com/apple/foundationdb/commit/8d04c97a74c6b83dd8aa6ff5af67587044c2a572.patch";
      hash = "sha256-ZLIcmcfirm1+96DtTIr53HfM5z38uTLZrRNHAmZL6rc=";
    })
  ];

  hardeningDisable = [ "fortify" ];

  postPatch = ''
    # allow using any msgpack-cxx version
    substituteInPlace cmake/GetMsgpack.cmake \
      --replace-warn 'find_package(msgpack-cxx 6 QUIET CONFIG)' 'find_package(msgpack-cxx QUIET CONFIG)'

    # Use our doctest package
    substituteInPlace bindings/c/test/unit/third_party/CMakeLists.txt \
      --replace-fail '/opt/doctest_proj_2.4.8' '${doctest}/include'

    # Upstream upgraded to Boost 1.86 with no code changes; see:
    # <https://github.com/apple/foundationdb/pull/11788>
    substituteInPlace cmake/CompileBoost.cmake \
      --replace-fail 'find_package(Boost 1.78.0 EXACT ' 'find_package(Boost '
  '';

  buildInputs = [
    boost
    jemalloc
    msgpack-cxx
    openssl
    toml11
  ];

  checkInputs = [ doctest ];

  nativeBuildInputs = [
    cmake
    mono
    ninja
    openjdk
    pkg-config
    python3
  ];

  separateDebugInfo = true;
  dontFixCmake = true;

  cmakeFlags = [
    "-DFDB_RELEASE=TRUE"

    # Disable CMake warnings for project developers.
    "-Wno-dev"

    # CMake Error at fdbserver/CMakeLists.txt:332 (find_library):
    # >   Could not find lz4_STATIC_LIBRARIES using the following names: liblz4.a
    "-DSSD_ROCKSDB_EXPERIMENTAL=FALSE"

    "-DBUILD_DOCUMENTATION=FALSE"

    # LTO brings up overall build time, but results in much smaller
    # binaries for all users and the cache.
    "-DUSE_LTO=ON"

    # Gold helps alleviate the link time, especially when LTO is
    # enabled. But even then, it still takes a majority of the time.
    "-DUSE_LD=GOLD"

    # FIXME: why can't openssl be found automatically?
    "-DOPENSSL_USE_STATIC_LIBS=FALSE"
    "-DOPENSSL_CRYPTO_LIBRARY=${openssl.out}/lib/libcrypto.so"
    "-DOPENSSL_SSL_LIBRARY=${openssl.out}/lib/libssl.so"
  ];

  # the install phase for cmake is pretty wonky right now since it's not designed to
  # coherently install packages as most linux distros expect -- it's designed to build
  # packaged artifacts that are shipped in RPMs, etc. we need to add some extra code to
  # cmake upstream to fix this, and if we do, i think most of this can go away.
  postInstall = ''
    mv $out/sbin/fdbmonitor $out/bin/fdbmonitor
    mkdir $out/libexec && mv $out/usr/lib/foundationdb/backup_agent/backup_agent $out/libexec/backup_agent
    mv $out/sbin/fdbserver $out/bin/fdbserver

    rm -rf $out/etc $out/lib/foundationdb $out/lib/systemd $out/log $out/sbin $out/usr $out/var

    # move results into multi outputs
    mkdir -p $dev $lib
    mv $out/include $dev/include
    mv $out/lib $lib/lib

    # python bindings
    # NB: use the original setup.py.in, so we can substitute VERSION correctly
    cp ../LICENSE ./bindings/python
    substitute ../bindings/python/setup.py.in ./bindings/python/setup.py \
      --replace 'VERSION' "${version}"
    rm -f ./bindings/python/setup.py.* ./bindings/python/CMakeLists.txt
    rm -f ./bindings/python/fdb/*.pth # remove useless files
    rm -f ./bindings/python/*.rst ./bindings/python/*.mk

    cp -R ./bindings/python/                          tmp-pythonsrc/
    tar -zcf $pythonsrc --transform s/tmp-pythonsrc/python-foundationdb/ ./tmp-pythonsrc/

    # java bindings
    mkdir -p $lib/share/java
    mv lib/fdb-java-*.jar $lib/share/java/fdb-java.jar
  '';

  outputs = [
    "out"
    "dev"
    "lib"
    "pythonsrc"
  ];

  meta = {
    description = "Open source, distributed, transactional key-value store";
    homepage = "https://www.foundationdb.org";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ] ++ lib.optionals (!(avxEnabled version)) [ "aarch64-linux" ];
    # Fails when cross-compiling with "/bin/sh: gcc-ar: not found"
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
    maintainers = with lib.maintainers; [
      thoughtpolice
      lostnet
    ];
  };
}
