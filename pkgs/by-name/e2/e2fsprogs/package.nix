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
  bash,
  bashNonInteractive,
}:

stdenv.mkDerivation rec {
  pname = "e2fsprogs";
  version = "1.47.3";

  __structuredAttrs = true;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/tytso/e2fsprogs/v${version}/e2fsprogs-${version}.tar.xz";
    hash = "sha256-hX5u+AD+qiu0V4+8gQIUvl08iLBy6lPFOEczqWVzcyk=";
  };

  patches = [
    # Upstream patch that fixes musl build (and probably others).
    # Should be included in next release after 1.47.3.
    (fetchpatch {
      name = "stdio-portability.patch";
      url = "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git/patch/?id=f79abd8554e600eacc2a7c864a8332b670c9e262";
      hash = "sha256-zZ7zmSMTwGyS3X3b/D/mVG0bV2ul5xtY5DJx9YUvQO8=";
    })
  ];

  # fuse2fs adds 14mb of dependencies
  outputs = [
    "bin"
    "dev"
    "out"
    "man"
    "info"
    "scripts"
  ]
  ++ lib.optionals withFuse [ "fuse2fs" ];

  strictDeps = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    pkg-config
    texinfo
  ];
  buildInputs = [
    libuuid
    gettext
    libarchive
    bash
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

    moveToOutput bin/mk_cmds "$scripts"
    moveToOutput bin/compile_et "$scripts"
    moveToOutput sbin/e2scrub "$scripts"
    moveToOutput sbin/e2scrub_all "$scripts"
  ''
  + lib.optionalString withFuse ''
    mkdir -p $fuse2fs/bin
    mv $bin/bin/fuse2fs $fuse2fs/bin/fuse2fs
  '';

  enableParallelBuilding = true;

  # non-glibc gettext has issues with this
  outputChecks = lib.optionalAttrs stdenv.hostPlatform.isGnu {
    bin.disallowedRequisites = [
      bash
      bashNonInteractive
    ];
    out.disallowedRequisites = [
      bash
      bashNonInteractive
    ];
  };

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
