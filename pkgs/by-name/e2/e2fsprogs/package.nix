{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  fetchpatch,
  pkg-config,
  libuuid,
  gettext,
  texinfo,
  withFuse ? stdenv.hostPlatform.isLinux,
  fuse3,
  shared ? !stdenv.hostPlatform.isStatic,
  e2fsprogs,
  runCommand,
  libarchive,
}:

stdenv.mkDerivation rec {
  pname = "e2fsprogs";
  version = "1.47.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/tytso/e2fsprogs/v${version}/e2fsprogs-${version}.tar.xz";
    hash = "sha256-CCQuZMoOgZTZwcqtSXYrGSCaBjGBmbY850rk7y105jw=";
  };

  # 2025-05-31: Fix libarchive, from https://github.com/tytso/e2fsprogs/pull/230
  patches = [
    (fetchpatch {
      name = "0001-create_inode_libarchive.c-define-libarchive-dylib-for-darwin.patch";
      url = "https://github.com/tytso/e2fsprogs/commit/e86c65bc7ee276cd9ca920d96e18ed0cddab3412.patch";
      hash = "sha256-HFZAznaNl5rzgVEvYx1LDKh2jd/VEXD/o0wypIh4TR8=";
    })
    (fetchpatch {
      name = "0002-mkgnutar.pl-avoid-uninitialized-username-variable.patch";
      url = "https://github.com/tytso/e2fsprogs/commit/9217c359db1d1b6d031a0e2ca9a885634fed00da.patch";
      hash = "sha256-iDXmLq77eJolH1mkXSbvZ9tRVtGQt2F45CdkVphUZSs=";
    })
  ];

  # fuse2fs adds 14mb of dependencies
  outputs = [
    "bin"
    "dev"
    "out"
    "man"
    "info"
  ]
  ++ lib.optionals withFuse [ "fuse2fs" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    pkg-config
    texinfo
  ];
  buildInputs = [
    libuuid
    gettext
    libarchive
  ]
  ++ lib.optionals withFuse [ fuse3 ];

  configureFlags = [
    "--with-libarchive=direct"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # It seems that the e2fsprogs is one of the few packages that cannot be
    # build with shared and static libs.
    (if shared then "--enable-elf-shlibs" else "--disable-elf-shlibs")
    "--enable-symlink-install"
    "--enable-relative-symlinks"
    "--with-crond-dir=no"
    # fsck, libblkid, libuuid and uuidd are in util-linux-ng (the "libuuid" dependency)
    "--disable-fsck"
    "--disable-libblkid"
    "--disable-libuuid"
    "--disable-uuidd"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
    "--enable-libuuid"
    "--disable-e2initrd-helper"
  ];

  nativeCheckInputs = [ buildPackages.perl ];
  doCheck = true;

  postInstall = ''
    # avoid cycle between outputs
    if [ -f $out/lib/${pname}/e2scrub_all_cron ]; then
      mv $out/lib/${pname}/e2scrub_all_cron $bin/bin/
    fi
  ''
  + lib.optionalString withFuse ''
    mkdir -p $fuse2fs/bin
    mv $bin/bin/fuse2fs $fuse2fs/bin/fuse2fs
  '';

  enableParallelBuilding = true;

  passthru.tests = {
    simple-filesystem = runCommand "e2fsprogs-create-fs" { } ''
      mkdir -p $out
      truncate -s10M $out/disc
      ${e2fsprogs}/bin/mkfs.ext4 $out/disc | tee $out/success
      ${e2fsprogs}/bin/e2fsck -n $out/disc | tee $out/success
      [ -e $out/success ]
    '';
  };

  meta = {
    homepage = "https://e2fsprogs.sourceforge.net/";
    changelog = "https://e2fsprogs.sourceforge.net/e2fsprogs-release.html#${version}";
    description = "Tools for creating and checking ext2/ext3/ext4 filesystems";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus # lib/ext2fs, lib/e2p
      bsd3 # lib/uuid
      mit # lib/et, lib/ss
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ usertam ];
  };
}
