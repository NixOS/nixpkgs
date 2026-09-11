{
  lib,
  stdenv,
  util-linux,
  coreutils,
  fetchgit,
  fetchurl,
  groff,
  system-sendmail,
  udev,
  udevCheckHook,
  gitUpdater,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mdadm";
  version = "4.6";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git";
    tag = "mdadm-${finalAttrs.version}";
    hash = "sha256-jFsVPJC4lcShkSwQCGjVdVkvk4q4weM7i5DzrLgpuSM=";
  };

  patches = [
    ./fix-hardcoded-mapdir.patch
  ];

  makeFlags = [
    "NIXOS=1"
    "INSTALL=install"
    "BINDIR=$(out)/sbin"
    "SYSTEMD_DIR=$(out)/lib/systemd/system"
    "MANDIR=$(man)/share/man"
    "RUN_DIR=/dev/.mdadm"
    "STRIP="
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  outputs = [
    "out"
    "man"
  ];

  installFlags = [ "install-systemd" ];

  enableParallelBuilding = true;

  buildInputs = [ udev ];

  nativeBuildInputs = [
    groff
    udevCheckHook
  ];

  doInstallCheck = true;

  postPatch = ''
    sed -e 's@/lib/udev@''${out}/lib/udev@' \
        -e 's@ -Werror @ @' \
        -e 's@/usr/sbin/sendmail@${system-sendmail}/bin/sendmail@' -i Makefile
    sed -i \
        -e 's@/usr/bin/basename@${coreutils}/bin/basename@g' \
        -e 's@BINDIR/blkid@${util-linux}/bin/blkid@g' \
        *.rules
  '';

  # This is to avoid self-references, which causes the initrd to explode
  # in size and in turn prevents mdraid systems from booting.
  postFixup = ''
    grep -r $out $out/bin && false || true
  '';

  passthru = {
    tests = {
      inherit (nixosTests) systemd-initrd-swraid;
      installer-swraid = nixosTests.installer.swraid;
    };
    updateScript = gitUpdater {
      url = "https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git";
      rev-prefix = "mdadm-";
    };
  };

  meta = {
    changelog = "https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/CHANGELOG.md?h=${finalAttrs.src.tag}";
    description = "Programs for managing RAID arrays under Linux";
    homepage = "https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git";
    license = lib.licenses.gpl2Plus;
    mainProgram = "mdadm";
    platforms = lib.platforms.linux;
  };
})
