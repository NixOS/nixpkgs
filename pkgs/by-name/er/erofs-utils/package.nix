{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  fuse3,
  util-linux,
  xxhash,
  lz4,
  xz,
  zlib,
  zstd,
  libdeflate,
  libselinux,
  fuseSupport ? stdenv.hostPlatform.isLinux,
  selinuxSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "erofs-utils";
  version = "1.9.2";
  outputs = [
    "out"
    "man"
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-${finalAttrs.version}.tar.gz";
    hash = "sha256-2RW0VkapKBdJF8RKLIS6AFsWHoSrcyzV0lYDcVYLjRM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    util-linux
    xxhash
    lz4
    zlib
    xz
    zstd
    libdeflate
  ]
  ++ lib.optionals fuseSupport [ fuse3 ]
  ++ lib.optionals selinuxSupport [ libselinux ];

  configureFlags = [
    "MAX_BLOCK_SIZE=4096"
    "--enable-multithreading"
    "--with-libdeflate"
  ]
  ++ lib.optional fuseSupport "--enable-fuse"
  ++ lib.optional selinuxSupport "--with-selinux";

  meta = {
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/about/";
    description = "Userspace utilities for linux-erofs file system";
    changelog = "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/tree/ChangeLog?h=v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      nikstur
      jmbaur
    ];
    platforms = lib.platforms.unix;
  };
})
