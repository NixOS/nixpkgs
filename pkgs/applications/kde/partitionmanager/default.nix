{ mkDerivation
, lib
, extra-cmake-modules
, kdoctools
, wrapGAppsHook
, kconfig
, kcrash
, kinit
, kpmcore
, polkit-qt
, cryptsetup
, lvm2
, mdadm
, smartmontools
, systemdMinimal
, util-linux
, btrfs-progs
, dosfstools
, e2fsprogs
, exfat
, f2fs-tools
, fatresize
, hfsprogs
, jfsutils
, nilfs-utils
, ntfs3g
, reiser4progs
, reiserfsprogs
, udftools
, xfsprogs
, zfs
}:

let
  # External programs are resolved by `partition-manager` and then
  # invoked by `kpmcore_externalcommand` from `kpmcore` as root.
  # So these packages should be in PATH of `partition-manager`.
  # https://github.com/KDE/kpmcore/blob/06f15334ecfbe871730a90dbe2b694ba060ee998/src/util/externalcommand_whitelist.h
  runtimeDeps = lib.makeBinPath [
    cryptsetup
    lvm2
    mdadm
    smartmontools
    systemdMinimal
    util-linux

    btrfs-progs
    dosfstools
    e2fsprogs
    exfat
    f2fs-tools
    fatresize
    hfsprogs
    jfsutils
    nilfs-utils
    ntfs3g
    reiser4progs
    reiserfsprogs
    udftools
    xfsprogs
    zfs

    # FIXME: Missing command: tune.exfat hfsck hformat fsck.nilfs2 {fsck,mkfs,debugfs,tunefs}.ocfs2
  ];

in
mkDerivation {
  pname = "partitionmanager";

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [ kconfig kcrash kinit kpmcore polkit-qt ];

  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : "${runtimeDeps}"
    )
  '';

  passthru = {
    inherit kpmcore;
  };

  meta = with lib; {
    description = "KDE Partition Manager";
    longDescription = ''
      KDE Partition Manager is a utility to help you manage the disks, partitions, and file systems on your computer.
      It allows you to easily create, copy, move, delete, back up, restore, and resize them without losing data.
      It supports a large number of file systems, including ext2/3/4, btrfs, reiserfs, NTFS, FAT16/32, JFS, XFS and more.

      To install on NixOS, use the option `programs.partition-manager.enable = true`.
    '';
    license = with licenses; [ cc-by-40 cc0 gpl3Plus lgpl3Plus mit ];
    homepage = "https://www.kde.org/applications/system/kdepartitionmanager/";
    maintainers = with maintainers; [ peterhoeg oxalica ];
    mainProgram = "partitionmanager";
  };
}
