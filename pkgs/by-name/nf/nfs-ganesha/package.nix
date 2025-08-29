{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  sphinx,
  krb5,
  xfsprogs,
  jemalloc,
  dbus,
  libcap,
  ntirpc,
  liburcu,
  bison,
  flex,
  nfs-utils,
  acl,
  useCeph ? false,
  ceph,
}:

stdenv.mkDerivation rec {
  pname = "nfs-ganesha";
  version = "6.5";

  outputs = [
    "out"
    "man"
    "tools"
  ];

  src = fetchFromGitHub {
    owner = "nfs-ganesha";
    repo = "nfs-ganesha";
    rev = "V${version}";
    hash = "sha256-OHGmEzHu8y/TPQ70E2sicaLtNgvlf/bRq8JRs6S1tpY=";
  };

  preConfigure = "cd src";

  cmakeFlags = [
    "-DUSE_SYSTEM_NTIRPC=ON"
    "-DSYSSTATEDIR=/var"
    "-DENABLE_VFS_POSIX_ACL=ON"
    "-DUSE_ACL_MAPPING=ON"
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
    "-DUSE_MAN_PAGE=ON"
  ]
  ++ lib.optionals useCeph [
    "-DUSE_RADOS_RECOV=ON"
    "-DRADOS_URLS=ON"
    "-DUSE_FSAL_CEPH=ON"
    "-DUSE_FSAL_RGW=ON"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    bison
    flex
    sphinx
  ];

  buildInputs = [
    acl
    krb5
    xfsprogs
    jemalloc
    dbus.lib
    libcap
    ntirpc
    liburcu
    nfs-utils
  ]
  ++ lib.optional useCeph ceph;

  postPatch = ''
    substituteInPlace src/tools/mount.9P --replace "/bin/mount" "/usr/bin/env mount"
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
    install -Dm755 $src/src/tools/mount.9P $tools/bin/mount.9P
  '';

  meta = with lib; {
    description = "NFS server that runs in user space";
    homepage = "https://github.com/nfs-ganesha/nfs-ganesha/wiki";
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
    license = licenses.lgpl3Plus;
    mainProgram = "ganesha.nfsd";
    outputsToInstall = [
      "out"
      "man"
      "tools"
    ];
  };
}
