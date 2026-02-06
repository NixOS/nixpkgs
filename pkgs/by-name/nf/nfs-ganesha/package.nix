{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  sphinx,
  krb5,
  xfsprogs,
  btrfs-progs,
  jemalloc,
  libcap,
  ntirpc,
  liburcu,
  bison,
  flex,
  nfs-utils,
  acl,
  prometheus-cpp-lite,
  useCeph ? false,
  ceph,
  useDbus ? true,
  dbus,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nfs-ganesha";
  version = "9.4";

  outputs = [
    "out"
    "man"
    "tools"
  ];

  src = fetchFromGitHub {
    owner = "nfs-ganesha";
    repo = "nfs-ganesha";
    tag = "V${finalAttrs.version}";
    hash = "sha256-Adax64aaioYfPg7SMtylS2wpYV52l8KgXBA8eJefGkY=";
  };

  patches = lib.optional useDbus ./allow-bypassing-dbus-pkg-config-test.patch;

  preConfigure = "cd src";

  env.NIX_CFLAGS_COMPILE = "-Wno-redundant-move";

  cmakeFlags = [
    "-DUSE_SYSTEM_NTIRPC=ON"
    "-DSYSSTATEDIR=/var"
    "-DENABLE_VFS_POSIX_ACL=ON"
    "-DUSE_ACL_MAPPING=ON"
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
    "-DUSE_MAN_PAGE=ON"
    "-DUSE_MONITORING=ON"
  ]
  ++ lib.optionals useCeph [
    "-DUSE_RADOS_RECOV=ON"
    "-DRADOS_URLS=ON"
    "-DUSE_FSAL_CEPH=ON"
    "-DUSE_FSAL_RGW=ON"
  ]
  ++ lib.optionals useDbus [
    "-DUSE_DBUS=ON"
    "-DDBUS_NO_PKGCONFIG=ON"
    "-DDBUS_LIBRARY_DIRS=${lib.getLib dbus}/lib"
    "-DDBUS_INCLUDE_DIRS=${lib.getDev dbus}/include/dbus-1.0\\;${lib.getLib dbus}/lib/dbus-1.0/include"
    "-DDBUS_LIBRARIES=dbus-1"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    bison
    flex
    sphinx
  ]
  ++ lib.optional useDbus dbus;

  buildInputs = [
    acl
    krb5
    xfsprogs
    btrfs-progs
    jemalloc
    dbus.lib
    libcap
    ntirpc
    liburcu
    nfs-utils
    prometheus-cpp-lite
  ]
  ++ lib.optional useCeph ceph;

  postPatch = ''
    substituteInPlace src/tools/mount.9P --replace-fail "/bin/mount" "/usr/bin/env mount"
  '';

  postFixup = ''
    patchelf --add-rpath $out/lib $out/bin/ganesha.nfsd
    patchelf --add-rpath $out/lib $out/lib/libganesha_nfsd.so
  ''
  + lib.optionalString useCeph ''
    patchelf --add-rpath $out/lib $out/bin/ganesha-rados-grace
    patchelf --add-rpath $out/lib $out/lib/libganesha_rados_recov.so
    patchelf --add-rpath $out/lib $out/lib/libganesha_rados_urls.so
  '';

  postInstall = ''
    install -Dm755 ../tools/mount.9P $tools/bin/mount.9P
  ''
  + lib.optionalString useDbus ''
    # Policy for D-Bus statistics interface
    install -Dm644 $src/src/scripts/ganeshactl/org.ganesha.nfsd.conf $out/etc/dbus-1/system.d/org.ganesha.nfsd.conf
  '';

  meta = {
    description = "NFS server that runs in user space";
    homepage = "https://github.com/nfs-ganesha/nfs-ganesha/wiki";
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl3Plus;
    mainProgram = "ganesha.nfsd";
    outputsToInstall = [
      "out"
      "man"
      "tools"
    ];
  };
})
