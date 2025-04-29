{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  fuse,
  util-linux,
  xxHash,
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
  version = "1.8.6";
  outputs = [
    "out"
    "man"
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-${finalAttrs.version}.tar.gz";
    hash = "sha256-WyIdw/1tFRQlswU07eRvt6kNwjOoZZy6A3J5awoGZUc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs =
    [
      util-linux
      xxHash
      lz4
      zlib
      xz
      zstd
      libdeflate
    ]
    ++ lib.optionals fuseSupport [ fuse ]
    ++ lib.optionals selinuxSupport [ libselinux ];

  configureFlags =
    [
      "MAX_BLOCK_SIZE=4096"
      "--enable-multithreading"
      "--with-libdeflate"
    ]
    ++ lib.optional fuseSupport "--enable-fuse"
    ++ lib.optional selinuxSupport "--with-selinux";

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/about/";
    description = "Userspace utilities for linux-erofs file system";
    changelog = "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/tree/ChangeLog?h=v${version}";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [
      ehmry
      nikstur
      jmbaur
    ];
    platforms = platforms.unix;
  };
})
