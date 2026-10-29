{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  zlib,
  curl,
  sqlite,
  libuuid,
  libarchive,
  fuse,
  fuse3,
  leveldb,
  protobuf,
  libcap,
  attr,
  c-ares,
  sparsehash,
  python3,
  perl,
  gdb,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "cvmfs";
  version = "2.13.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "cvmfs";
    repo = "cvmfs";
    tag = "cvmfs-${version}";
    hash = "sha256-lMqEDOJnn8OuwxLFFzWSaAfsFJKZoMitS9ziyPO0ca0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    perl
    gdb
    curl # cmake runs curl-config --features at configure time
    protobuf # protoc is needed at build time to generate .pb.h/.pb.cc
  ];

  buildInputs = [
    openssl
    zlib
    curl
    sqlite
    libuuid
    libarchive
    fuse
    fuse3
    leveldb
    protobuf
    libcap
    attr
    c-ares
    sparsehash
  ];

  postPatch = ''
    # mount.cvmfs looks for cvmfs2 in /usr/bin
    substituteInPlace mount/mount.cvmfs.cc \
      --replace-fail '"/usr/bin"' '"${placeholder "out"}/bin"'

    # cvmfs2 dlopen()s libcvmfs_fuse*.so at runtime from hardcoded /usr/lib paths.
    # Two code paths: fuse_main.cc (initial load) and loader.cc (reload).
    substituteInPlace cvmfs/fuse_main.cc \
      --replace-fail \
        'library_paths.push_back("/usr/lib/" + libname_fuse3);' \
        'library_paths.push_back("${placeholder "out"}/lib/" + libname_fuse3);
    library_paths.push_back("/usr/lib/" + libname_fuse3);'

    substituteInPlace cvmfs/fuse_main.cc \
      --replace-fail \
        'library_paths.push_back("/usr/lib/" + libname_fuse2);' \
        'library_paths.push_back("${placeholder "out"}/lib/" + libname_fuse2);
    library_paths.push_back("/usr/lib/" + libname_fuse2);'

    substituteInPlace cvmfs/loader.cc \
      --replace-fail \
        'library_paths.push_back("/usr/lib/" + library_name);' \
        'library_paths.push_back("${placeholder "out"}/lib/" + library_name);
    library_paths.push_back("/usr/lib/" + library_name);'

    # Authz helper path
    substituteInPlace cvmfs/mountpoint.cc \
      --replace-fail '"/usr/libexec/cvmfs/authz"' \
                     '"${placeholder "out"}/libexec/cvmfs/authz"'

    # Use system OpenSSL instead of vendored LibreSSL (API-compatible)
    substituteInPlace cvmfs/crypto/openssl_version.h \
      --replace-fail '#error "picking up OpenSSL includes instead of LibreSSL"' \
                     '/* using system OpenSSL instead of LibreSSL */'

    # Remove autofs symlink creation (fails in sandbox, not needed with systemd automount)
    sed -i '/install(CODE/,/^[[:space:]]*")/d' mount/CMakeLists.txt

    # Fix systemd unit install path
    substituteInPlace cvmfs/CMakeLists.txt \
      --replace-fail 'DESTINATION /usr/lib/systemd/system' \
                     'DESTINATION ''${CMAKE_INSTALL_PREFIX}/lib/systemd/system'

    # Fix mount helper install path (/sbin -> $out/bin)
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set (CMAKE_MOUNT_INSTALL_BINDIR "/sbin")' \
                     'set (CMAKE_MOUNT_INSTALL_BINDIR "''${CMAKE_INSTALL_PREFIX}/bin")' \
      --replace-fail 'set (CMAKE_MOUNT_INSTALL_BINDIR "/usr/bin")' \
                     'set (CMAKE_MOUNT_INSTALL_BINDIR "''${CMAKE_INSTALL_PREFIX}/bin")'
  '';

  cmakeFlags = [
    "-DBUILD_CVMFS=ON"
    "-DBUILD_LIBCVMFS=OFF"
    "-DBUILD_LIBCVMFS_CACHE=OFF"
    "-DBUILD_SERVER=OFF"
    "-DBUILD_SERVER_DEBUG=OFF"
    "-DBUILD_RECEIVER=OFF"
    "-DBUILD_GEOAPI=OFF"
    "-DBUILD_GATEWAY=OFF"
    "-DBUILD_DUCC=OFF"
    "-DBUILD_SNAPSHOTTER=OFF"
    "-DBUILD_UNITTESTS=OFF"
    "-DBUILD_UNITTESTS_CVMFS=OFF"
    "-DBUILD_PRELOADER=OFF"
    "-DBUILD_SHRINKWRAP=OFF"
    "-DINSTALL_MOUNT_SCRIPTS=ON"
    "-DINSTALL_PUBLIC_KEYS=ON"
    "-DINSTALL_BASH_COMPLETION=OFF"
    "-DBUILTIN_EXTERNALS=OFF"
    # FindLibcrypto.cmake only searches EXTERNALS_INSTALL_LOCATION; bypass it
    "-DLibcrypto_INCLUDE_DIRS=${openssl.dev}/include"
    "-DLibcrypto_LIBRARIES=${openssl.out}/lib/libcrypto.so"
  ];

  # vjson, sha3, and pacparser are vendored libraries not available in nixpkgs.
  # Build them from CVMFS's bundled sources before CMake runs.
  preConfigure = ''
    export CVMFS_EXTERNALS=$TMPDIR/cvmfs-externals
    mkdir -p $CVMFS_EXTERNALS/{lib,include}

    # vjson
    pushd externals/vjson/src
    make clean 2>/dev/null || true
    make CVMFS_BASE_CXX_FLAGS="$NIX_CFLAGS_COMPILE" -j$NIX_BUILD_CORES
    cp json.h block_allocator.h $CVMFS_EXTERNALS/include/
    cp libvjson.a $CVMFS_EXTERNALS/lib/
    popd

    # sha3 (Keccak)
    pushd externals/sha3/src
    echo 64opt > arch
    rm -f SnP-interface.h
    ln -s 64opt/SnP-interface.h SnP-interface.h
    make clean 2>/dev/null || true
    make CVMFS_BASE_C_FLAGS="$NIX_CFLAGS_COMPILE" ARCH=64opt -j$NIX_BUILD_CORES
    cp *.h $CVMFS_EXTERNALS/include/
    cp libsha3.a $CVMFS_EXTERNALS/lib/
    popd

    # pacparser (bundles ancient SpiderMonkey — build only library targets, skip tests)
    pushd externals/pacparser
    tar xzf pacparser-1.4.3.tar.gz
    cd pacparser-1.4.3
    for p in ../src/fix_cflags.patch ../src/fix_c99.patch \
             ../src/fix_git_dependency.patch ../src/fix_python_setuptools.patch \
             ../src/fix_gcc14.patch; do
      patch -p0 < "$p"
    done
    patchShebangs .
    find . -name "Makefile" -exec sed -i -e 's|/bin/bash|bash|g' -e 's|/bin/true|true|g' {} +
    NIX_HARDENING_ENABLE="" \
    make PYTHON=python3 -C src clean -j$NIX_BUILD_CORES || true
    NIX_HARDENING_ENABLE="" \
    make PYTHON=python3 CVMFS_BASE_C_FLAGS="-Wno-error -Wno-cpp" \
         -j1 -C src pacparser.o spidermonkey/libjs.a
    mkdir -p src/static
    cp src/pacparser.o src/spidermonkey/libjs.a src/static/
    pushd src/static
    ar x libjs.a
    rm -f libjs.a
    ar rcs libpacparser.a *.o
    rm -f *.o
    popd
    cp src/pacparser.h $CVMFS_EXTERNALS/include/
    cp src/static/libpacparser.a $CVMFS_EXTERNALS/lib/
    popd

    cmakeFlagsArray+=(
      "-DVJSON_INCLUDE_DIRS=$CVMFS_EXTERNALS/include"
      "-DVJSON_LIBRARIES=$CVMFS_EXTERNALS/lib/libvjson.a"
      "-DSHA3_INCLUDE_DIRS=$CVMFS_EXTERNALS/include"
      "-DSHA3_LIBRARIES=$CVMFS_EXTERNALS/lib/libsha3.a"
      "-DPACPARSER_INCLUDE_DIR=$CVMFS_EXTERNALS/include"
      "-DPACPARSER_LIBRARIES=$CVMFS_EXTERNALS/lib/libpacparser.a"
    )
  '';

  postInstall = ''
    if [ -f "$out/sbin/mount.cvmfs" ] && [ ! -f "$out/bin/mount.cvmfs" ]; then
      mv "$out/sbin/mount.cvmfs" "$out/bin/mount.cvmfs"
    fi
    if [ -f "$out/bin/mount.cvmfs" ] && [ ! -f "$out/bin/mount.fuse.cvmfs2" ]; then
      ln -s mount.cvmfs "$out/bin/mount.fuse.cvmfs2"
    fi
  '';

  # dlopen'd libraries need $ORIGIN in RPATH to find sibling libs
  postFixup = ''
    for lib in $out/lib/libcvmfs_fuse3.so.* $out/lib/libcvmfs_fuse3_debug.so.*; do
      [ -L "$lib" ] && continue
      patchelf --add-rpath '$ORIGIN' "$lib"
    done
  '';

  passthru.tests.nixos = nixosTests.cvmfs;

  meta = {
    description = "CernVM File System client for software distribution via FUSE";
    homepage = "https://cernvm.cern.ch/fs/";
    changelog = "https://github.com/cvmfs/cvmfs/releases/tag/cvmfs-${version}";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ olantwin ];
    mainProgram = "cvmfs2";
  };
}
