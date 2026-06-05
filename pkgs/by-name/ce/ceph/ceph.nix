{
  lib,
  stdenv,
  overrideScope,
  ceph-meta,
  ceph-src,

  # Build time
  autoconf,
  automake,
  cmake,
  ensureNewerSourcesHook,
  fmt,
  git,
  libtool,
  makeWrapper,
  nasm,
  pkg-config,
  which,

  # Tests
  nixosTests,

  # Runtime dependencies

  arrow-cpp,
  babeltrace,
  ceph-boost,
  bzip2,
  cryptsetup,
  cunit,
  e2fsprogs,
  doxygen,
  getopt,
  gperf,
  graphviz,
  gnugrep,
  gtest,
  icu,
  kmod,
  libcap,
  libcap_ng,
  libnbd,
  libnl,
  libxml2,
  lmdb,
  lttng-ust,
  # Ceph currently requires >= 5.3
  lua5_4,
  lvm2,
  lz4,
  oath-toolkit,
  openldap,
  parted,
  ceph-python-env,
  rdkafka,
  ceph-rocksdb,
  snappy,
  openssh,
  sqlite,
  utf8proc,
  xfsprogs,
  zlib,
  zstd,

  # Optional Dependencies
  curl,
  expat,
  fuse,
  libatomic_ops,
  libedit,
  libs3,
  yasm,

  # Mallocs
  gperftools,
  jemalloc,

  # Crypto Dependencies
  cryptopp,
  nspr,
  nss,

  # Linux Only Dependencies
  linuxHeaders,
  systemd,
  util-linux,
  libuuid,
  udev,
  keyutils,
  rdma-core,
  rabbitmq-c,
  libaio,
  libxfs,
  liburing,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

# We must have one crypto library
assert cryptopp != null || (nss != null && nspr != null);

let
  shouldUsePkg =
    pkg: if pkg != null && lib.meta.availableOn stdenv.hostPlatform pkg then pkg else null;

  optYasm = shouldUsePkg yasm;
  optExpat = shouldUsePkg expat;
  optCurl = shouldUsePkg curl;
  optFuse = shouldUsePkg fuse;
  optLibedit = shouldUsePkg libedit;
  optLibatomic_ops = shouldUsePkg libatomic_ops;
  optLibs3 = shouldUsePkg libs3;

  optJemalloc = shouldUsePkg jemalloc;
  optGperftools = shouldUsePkg gperftools;

  optCryptopp = shouldUsePkg cryptopp;
  optNss = shouldUsePkg nss;
  optNspr = shouldUsePkg nspr;

  optLibaio = shouldUsePkg libaio;
  optLibxfs = shouldUsePkg libxfs;

  hasRadosgw = optExpat != null && optCurl != null && optLibedit != null;

  # Malloc implementation (can be jemalloc, tcmalloc or null)
  malloc = if optJemalloc != null then optJemalloc else optGperftools;

  # We prefer nss over cryptopp
  cryptoStr =
    if optNss != null && optNspr != null then
      "nss"
    else if optCryptopp != null then
      "cryptopp"
    else
      "none";

  cryptoLibsMap = {
    nss = [
      optNss
      optNspr
    ];
    cryptopp = [ optCryptopp ];
    none = [ ];
  };

in
stdenv.mkDerivation {
  pname = "ceph";
  inherit (ceph-src) version;
  src = ceph-src;

  nativeBuildInputs = [
    autoconf # `autoreconf` is called, e.g. for `qatlib_ext`
    automake # `aclocal` is called, e.g. for `qatlib_ext`
    cmake
    fmt
    git
    makeWrapper
    libtool # used e.g. for `qatlib_ext`
    nasm
    pkg-config
    ceph-python-env
    ceph-python-env.pkgs.python # for the toPythonPath function
    ceph-python-env.pkgs.wrapPython
    which
    (ensureNewerSourcesHook { year = "1980"; })
    # for building docs/man-pages presumably
    doxygen
    graphviz
  ];

  buildInputs =
    cryptoLibsMap.${cryptoStr}
    ++ [
      arrow-cpp
      babeltrace
      ceph-boost
      bzip2
      # Adding `ceph-python-env` here adds the env's `site-packages` to `PYTHONPATH` during the build.
      # This is important, otherwise the build system may not find the Python deps and then
      # silently skip installing ceph-volume and other Ceph python tools.
      ceph-python-env
      cryptsetup
      cunit
      e2fsprogs # according to `debian/control` file, `ceph-volume` is supposed to use it
      gperf
      gtest
      icu
      libcap
      libnbd
      libnl
      libxml2
      lmdb
      lttng-ust
      lua5_4
      lvm2 # according to `debian/control` file, e.g. `pvs` command used by `src/ceph-volume/ceph_volume/api/lvm.py`
      lz4
      malloc
      oath-toolkit
      openldap
      optLibatomic_ops
      optLibs3
      optYasm
      parted # according to `debian/control` file, used by `src/ceph-volume/ceph_volume/util/disk.py`
      rdkafka
      ceph-rocksdb
      snappy
      openssh # according to `debian/control` file, `ssh` command used by `cephadm`
      sqlite
      utf8proc
      xfsprogs # according to `debian/control` file, `ceph-volume` is supposed to use it
      zlib
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      keyutils
      libcap_ng
      liburing
      libuuid
      linuxHeaders
      optLibaio
      optLibxfs
      rabbitmq-c
      rdma-core
      udev
      util-linux
    ]
    ++ lib.optionals hasRadosgw [
      optCurl
      optExpat
      optFuse
      optLibedit
    ];

  inherit (ceph-python-env) sitePackages;

  # Picked up, amongst others, by `wrapPythonPrograms`.
  pythonPath = [
    ceph-python-env
    "${placeholder "out"}/${ceph-python-env.sitePackages}"
  ];

  # * `unset AS` because otherwise the Ceph CMake build errors with
  #       configure: error: No modern nasm or yasm found as required. Nasm should be v2.11.01 or later (v2.13 for AVX512) and yasm should be 1.2.0 or later.
  #   because the code at
  #       https://github.com/intel/isa-l/blob/633add1b569fe927bace3960d7c84ed9c1b38bb9/configure.ac#L99-L191
  #   doesn't even consider using `nasm` or `yasm` but instead uses `$AS`
  #   from `gcc-wrapper`.
  #   (Ceph's error message is extra confusing, because it says
  #   `No modern nasm or yasm found` when in fact it found e.g. `nasm`
  #   but then uses `$AS` instead.
  # * replace /sbin and /bin based paths with direct nix store paths
  # * increase the `command` buffer size since 2 nix store paths cannot fit within 128 characters
  preConfigure = ''
    unset AS

    substituteInPlace src/common/module.c \
      --replace-fail "char command[128];" "char command[256];" \
      --replace-fail "/sbin/modinfo"  "${kmod}/bin/modinfo" \
      --replace-fail "/sbin/modprobe" "${kmod}/bin/modprobe" \
      --replace-fail "/bin/grep" "${gnugrep}/bin/grep"

    # Patch remount to use full path to mount(8), otherwise ceph-fuse fails when run
    # from a systemd unit for example.
    substituteInPlace src/client/fuse_ll.cc \
      --replace-fail "mount -i -o remount" "${util-linux}/bin/mount -i -o remount"

    substituteInPlace systemd/*.service.in \
      --replace-quiet "/bin/kill" "${util-linux}/bin/kill"

    substituteInPlace src/{ceph-osd-prestart.sh,ceph-post-file.in,init-ceph.in} \
       --replace-fail "GETOPT=/usr/local/bin/getopt" "GETOPT=${getopt}/bin/getopt" \
       --replace-fail "GETOPT=getopt" "GETOPT=${getopt}/bin/getopt"

    # The install target needs to be in PYTHONPATH for "*.pth support" check to succeed
    export PYTHONPATH=$PYTHONPATH:$lib/$sitePackages:$out/$sitePackages
    patchShebangs src/
  '';

  cmakeFlags = [
    (lib.cmakeOptionType "path" "CMAKE_INSTALL_DATADIR" "${placeholder "lib"}/lib")

    (lib.cmakeBool "WITH_CEPHFS_SHELL" true)
    (lib.cmakeBool "WITH_SYSTEMD" withSystemd)
    # Providing a type with this (as is the case with `lib.cmakeOptionType`) triggers an edge case.
    # This requires an upstream fix/patch as soon as upstream raises the minimum CMake version to 3.21 or higher.
    # See also: https://github.com/NixOS/nixpkgs/pull/494583#issuecomment-4195176699
    "-DSYSTEMD_SYSTEM_UNIT_DIR=${placeholder "out"}/lib/systemd/system"
    # `WITH_JAEGER` requires `thrift` as a depenedncy (fine), but the build fails with:
    #     CMake Error at src/opentelemetry-cpp-stamp/opentelemetry-cpp-build-Release.cmake:49 (message):
    #     Command failed: 2
    #
    #        'make' 'opentelemetry_trace' 'opentelemetry_exporter_jaeger_trace'
    #
    #     See also
    #
    #        /build/ceph-18.2.0/build/src/opentelemetry-cpp/src/opentelemetry-cpp-stamp/opentelemetry-cpp-build-*.log
    # and that file contains:
    #     /build/ceph-18.2.0/src/jaegertracing/opentelemetry-cpp/exporters/jaeger/src/TUDPTransport.cc: In member function 'virtual void opentelemetry::v1::exporter::jaeger::TUDPTransport::close()':
    #     /build/ceph-18.2.0/src/jaegertracing/opentelemetry-cpp/exporters/jaeger/src/TUDPTransport.cc:71:7: error: '::close' has not been declared; did you mean 'pclose'?
    #       71 |     ::THRIFT_CLOSESOCKET(socket_);
    #          |       ^~~~~~~~~~~~~~~~~~
    # Looks like `close()` is somehow not included.
    # But the relevant code is already removed in `open-telemetry` 1.10: https://github.com/open-telemetry/opentelemetry-cpp/pull/2031
    # So it's probably not worth trying to fix that for this Ceph version,
    # and instead just disable Ceph's Jaeger support.
    (lib.cmakeBool "WITH_JAEGER" false)
    (lib.cmakeBool "WITH_TESTS" false)

    # Use our own libraries, where possible
    (lib.cmakeBool "WITH_SYSTEM_ARROW" true) # Only used if other options enable Arrow support.
    (lib.cmakeBool "WITH_SYSTEM_BOOST" true)
    (lib.cmakeBool "WITH_SYSTEM_GTEST" true)
    (lib.cmakeBool "WITH_SYSTEM_ROCKSDB" true)
    (lib.cmakeBool "WITH_SYSTEM_UTF8PROC" true)
    (lib.cmakeBool "WITH_SYSTEM_ZSTD" true)

    # Use our own python libraries too, see:
    #     https://github.com/NixOS/nixpkgs/pull/344993#issuecomment-2391046329
    (lib.cmakeFeature "CEPHADM_BUNDLED_DEPENDENCIES" "none")

    # Upstream enables UADK by default on aarch64, but not other platforms.
    # This causes issues when it tries to fetch the repository on aarch64.
    # We disable this by default on all platforms, with future PRs adding proper with<Pkg> flags.
    (lib.cmakeBool "WITH_UADK" false)

    # TODO breaks with sandbox, tries to download stuff with npm
    (lib.cmakeBool "WITH_MGR_DASHBOARD_FRONTEND" false)
    # WITH_XFS has been set default ON from Ceph 16, keeping it optional in nixpkgs for now
    (lib.cmakeBool "WITH_XFS" (optLibxfs != null))
  ]
  # TODO: investigate setting this to false on other platforms
  ++ lib.optional stdenv.hostPlatform.isLinux (lib.cmakeBool "WITH_SYSTEM_LIBURING" true);

  preBuild =
    # The legacy-option-headers target is not correctly empbedded in the build graph.
    # It also contains some internal race conditions that we work around by building with `-j 1`.
    # Upstream discussion for additional context at https://tracker.ceph.com/issues/63402.
    ''
      cmake --build . --target legacy-option-headers -j 1
    '';

  postFixup = ''
    wrapPythonPrograms
    # dashboard-related ceph-mgr functionality needs access to the *rados-admin* binary in addition to the python part
    wrapProgram $out/bin/ceph-mgr \
      --prefix PYTHONPATH : "$(toPythonPath ${placeholder "out"}):$(toPythonPath ${ceph-python-env})" \
      --prefix PATH : $out/bin

    # Test that ceph-volume exists since the build system has a tendency to
    # silently drop it with misconfigurations.
    test -f $out/bin/ceph-volume

    # Assert that getopt patch from preConfigure covered all instances
    ! grep -F -r 'GETOPT=getopt' $out
    ! grep -F -r 'GETOPT=/usr/local/bin/getopt' $out

    mkdir -p $client/{bin,etc,$sitePackages,share/bash-completion/completions}
    cp -r $out/bin/{ceph,.ceph-wrapped,rados,rbd,rbdmap} $client/bin
    cp -r $out/bin/ceph-{authtool,conf,dencoder,rbdnamer,syn} $client/bin
    cp -r $out/bin/rbd-replay* $client/bin
    cp -r $out/sbin/mount.ceph $client/bin
    cp -r $out/sbin/mount.fuse.ceph $client/bin
    ln -s bin $client/sbin
    cp -r $out/$sitePackages/* $client/$sitePackages
    cp -r $out/etc/bash_completion.d $client/share/bash-completion/completions
    # wrapPythonPrograms modifies .ceph-wrapped, so lets just update its paths
    substituteInPlace $client/bin/ceph          --replace-fail $out $client
    substituteInPlace $client/bin/.ceph-wrapped --replace-fail $out $client
  '';

  outputs = [
    "out"
    "lib"
    "client"
    "dev"
    "doc"
    "man"
  ];

  doCheck = false; # uses pip to install things from the internet

  # Takes 7+h to build with 2 cores.
  requiredSystemFeatures = [ "big-parallel" ];

  meta = ceph-meta "Distributed storage system";

  passthru = {
    inherit (ceph-src) version;
    inherit overrideScope;
    inherit arrow-cpp;
    pythonEnv = ceph-python-env;
    tests = {
      inherit (nixosTests)
        ceph-multi-node
        ceph-single-node
        ceph-single-node-bluestore
        ceph-single-node-bluestore-dmcrypt
        ;
    };
  };
}
