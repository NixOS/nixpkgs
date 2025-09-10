{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  pkg-config,
  zstd,
  acl,
  attr,
  e2fsprogs,
  libuuid,
  lzo,
  udev,
  zlib,
  runCommand,
  btrfs-progs,
  gitUpdater,
  udevSupport ? true,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "btrfs-progs";
  version = "6.16";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${version}.tar.xz";
    hash = "sha256-Makw+HN8JhioJK1L0f3YP1QQPg6qFaqtxIT/rjNGb8U=";
  };

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals udevSupport [
    udevCheckHook
  ]
  ++ [
    (buildPackages.python3.withPackages (
      ps: with ps; [
        sphinx
        sphinx-rtd-theme
      ]
    ))
  ];

  buildInputs = [
    acl
    attr
    e2fsprogs
    libuuid
    lzo
    udev
    zlib
    zstd
  ];

  # gcc bug with -O1 on ARM with gcc 4.8
  # This should be fine on all platforms so apply universally
  postPatch = "sed -i s/-O1/-O2/ configure";

  postInstall = ''
    install -v -m 444 -D btrfs-completion $out/share/bash-completion/completions/btrfs
  '';

  configureFlags = [
    # Built separately, see python3Packages.btrfsutil
    "--disable-python"
  ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [
    "--disable-backtrace"
  ]
  ++ lib.optionals (!udevSupport) [
    "--disable-libudev"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  makeFlags = [ "udevruledir=$(out)/lib/udev/rules.d" ];

  enableParallelBuilding = true;

  doInstallCheck = true;

  passthru.tests = {
    simple-filesystem = runCommand "btrfs-progs-create-fs" { } ''
      mkdir -p $out
      truncate -s110M $out/disc
      ${btrfs-progs}/bin/mkfs.btrfs $out/disc | tee $out/success
      ${btrfs-progs}/bin/btrfs check $out/disc | tee $out/success
      [ -e $out/success ]
    '';
  };

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://github.com/kdave/btrfs-progs.git";
    rev-prefix = "v";
  };

  meta = {
    description = "Utilities for the btrfs filesystem";
    homepage = "https://btrfs.readthedocs.io/en/latest/";
    changelog = "https://github.com/kdave/btrfs-progs/raw/v${version}/CHANGES";
    license = lib.licenses.gpl2Only;
    mainProgram = "btrfs";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
  };
}
