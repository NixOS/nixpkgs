import ./make-test-python.nix ({ lib, pkgs, ... } : let
  # It's kind of awkward that this is required...
  # Is there a better way to do this?
  # We now have to rebuild ZFS.
  zfsForTesting = pkgs.zfs.overrideAttrs (oldAttrs: {
    removeTests = false;
    postPatch = (oldAttrs.postPatch or "") + ''
      # TODO(ricsch): Is overriding with /run/current-system/sw/bin acceptable?
      substituteInPlace scripts/zfs-tests.sh \
          --replace '$STF_PATH/ksh' ${pkgs.ksh}/bin/ksh \
          --replace 'LOSETUP=' 'LOSETUP=${pkgs.util-linux}/bin/losetup #' \
          --replace 'export PATH=$STF_PATH' '#' \
          --replace 'DMSETUP=' 'DMSETUP=${pkgs.lvm2}/bin/dmsetup #' \
          --replace '$STF_PATH/gzip' '${pkgs.gzip}/bin/gzip' \
          --replace '$STF_PATH/gunzip' '${pkgs.gzip}/bin/gunzip' \
          --replace '/sbin/fsck.ext4' '${pkgs.e2fsprogs}/bin/fsck.ext4' \
          --replace '/sbin/mkfs.ext4' '${pkgs.e2fsprogs}/bin/mkfs.ext4' \
          --replace '$STF_PATH/awk' '${pkgs.gawk}/bin/awk' \
          --replace 'SYSTEM_DIRS="/usr/local/bin /usr/local/sbin"' 'SYSTEM_DIRS="/run/current-system/sw/bin"'

      substituteInPlace scripts/common.sh.in \
          --replace 'export ZDB=' 'export ZDB=$out/bin/zdb #' \
          --replace 'export ZFS=' 'export ZFS=$out/bin/zfs #' \
          --replace 'export ZPOOL=' 'export ZPOOL=$out/bin/zpool #' \
          --replace 'export ZTEST=' 'export ZTEST=$out/bin/ztest #' \
          --replace 'export ZFS_SH=' 'export ZFS_SH=$out/share/zfs/zfs.sh #'

      # Fix ksh paths in test suite.
      # patchShebangs doesn't work due to the scripts not being executable.
      # It doesn't seem logical to make them executable either.
      find -name "*.ksh" -exec sed -i 's,/bin/ksh,${pkgs.ksh}/bin/ksh,' {} \;

      # Patching maybe required for more binaries
      # Maybe FHS environment would be better?
    '';
    postInstall = (oldAttrs.postInstall or "") + ''
      # Ensure that the tests are not deleted.
      # This is a requirement.
      ls $out/share/zfs/zfs-tests || exit 1
    '';
  });
  zfsRunFile = pkgs.writeText "zfs-sanity.run" ./zfs-sanity.run;
in {
  name = "zfs-tests";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mindavi ];
  };


  machine =
    { lib, pkgs, config, ... }:
    with lib;
    {
      imports = [ ./common/user-account.nix ];
      # User must be in wheel group, without requiring password entry.
      users.users.alice = { isNormalUser = true; group = "wheel"; };
      security.sudo.wheelNeedsPassword = false;

      # The default size of 512 MB was not enough, so bump it to be safe.
      # E.g. functional/pool_checkpoint/setup uses quite a bit of harddrive space.
      virtualisation.diskSize = 8192;
      # ZFS uses quite a bit of RAM.
      # This seems like a generous enough amount of memory.
      virtualisation.memorySize = 4096;
      # TODO(mindavi): Does it help to assign multiple cores?
      virtualisation.cores = 2;

      # This prevents that grub is rebuild / included in closure.
      # It doesn't seem to be used anyway, because disabling helps :).
      boot.loader.grub.enable = false;

      boot.kernelModules = [ "zfs" ];
      boot.supportedFilesystems = [ "zfs" ];
      environment.systemPackages = [
        pkgs.gcc
        zfsForTesting
        pkgs.ksh
        pkgs.util-linux
        pkgs.coreutils
        pkgs.sudo
        pkgs.lvm2
        pkgs.gawk
        pkgs.e2fsprogs # mkfs.ext4
        pkgs.gzip # gzip, gunzip
        pkgs.procps
        pkgs.acl # setfacl, getfacl
        pkgs.python2
        pkgs.python3
        pkgs.openssl
        pkgs.bc
        pkgs.nfs-utils
        pkgs.dmidecode
        pkgs.lsscsi
        pkgs.file
        pkgs.sysstat # iostat
        pkgs.pax
        pkgs.binutils # strings
        pkgs.parted
        pkgs.linuxPackages.perf
        pkgs.samba # net
        #pkgs.fio # disable because of kernel crashes... / hangs
        # exportfs -> nfs-utils?
      ];
      networking.hostId = "abcdef01";
    };

  testScript = ''
      start_all()
      machine.wait_for_unit("multi-user.target")
      machine.succeed("modprobe zfs", "zfs version", "id")

      # Check if the runfile is copied properly (for development, remove later)
      machine.succeed(
          "grep 'Common Development' `cat ${zfsRunFile}`"
      )

      # Running all tests takes very long (multiple hours) and doesn't work properly.
      # We'll just do a quick smoke-test.

      # test run results (no extra text means PASS):
      # - chattr
      # - checksum
      # - deadman
      # - devices
      # - fallocate
      # - snapshot
      # - tmpfile
      # - upgrade
      # - userquota
      # - zdb
      # - zfs
      # - zfs_sysfs
      # - zpool_add
      # - zpool_reopen
      # - compression (4 FAIL)
      #   - compression/l2arc_compressed_arc
      #   - compression/l2arc_compressed_arc_disabled
      #   - compression/l2arc_encrypted
      #   - compression/l2arc_encrypted_no_compressed_arc
      # - events (3 FAIL)
      #   - events/events_001_pos
      #   - events/events_002_pos
      #   - events/zed_rc_filter
      # - exec (1 FAIL)
      #   - exec/exec_001_pos
      # - fault (takes very long, doesn't terminate?)
      # - large_dnode (1 FAIL)
      #   - features/large_dnode/large_dnode_006_pos
      # - misc (1 FAIL)
      #   - cli_user/misc/arc_summary_001_pos
      # - mmp (14 SKIP)
      # - rsend (takes very long, errors out with ENOSPC)
      # - user_namespace (1 FAIL)
      # - zfs_mount (2 FAIL)
      #   - cli_root/zfs_mount/zfs_mount_013_pos
      #   - cli_root/zfs_mount/zfs_multi_mount
      # - zfs_share (2 FAIL, 13 SKIP)
      #   - cli_root/zfs_share/setup
      # - zpool_create (1 FAIL)
      #   - cli_root/zpool_create/zpool_create_014_neg
      # - zpool_expand (1 FAIL)
      #   - cli_root/zpool_expand/zpool_expand_001_pos
      # - zpool_split (1 SKIP)
      #   - cli_root/zpool_split/zpool_split_props

      # TODO
      # - io (broken? fio)
      # - pool_checkpoint (takes > 15 minutes)
      # - cache (fio)
      # - trim (fio)
      # - l2arc (fio)
      # - pam (pamtester)

      tests_to_run = [
          # 00:07
          "chattr",
          # 01:47
          # "checksum",
          # 01:00
          # "deadman",
          # 00:04
          "devices",
          # 00:02
          "fallocate",
          # 01:03
          "snapshot",
          # 00:02
          "tmpfile",
          # 00:22
          # "upgrade",
          # 00:58
          # "userquota",
          # 04:51
          # "zdb",
          # 00:43
          "zfs",
          # 00:04
          "zfs_sysfs",
          # 04:54
          # "zpool_add",
          # 03:06
          # "zpool_reopen",
      ]

      for test in tests_to_run:
          machine.succeed(
              f"su - alice -- ${zfsForTesting}/share/zfs/zfs-tests.sh -T {test} >> test-results.log",
          )
          # Show the last lines of the test results log.
          print(machine.execute("tail -n30 test-results.log")[1])

      # print(
      #     machine.execute(
      #         # "su - alice -- ${zfsForTesting}/share/zfs/zfs-tests.sh -r ${zfsForTesting}/share/zfs/runfiles/sanity.run"
      #         "su - alice -- ${zfsForTesting}/share/zfs/zfs-tests.sh -r `cat ${zfsRunFile}`"
      #     )[1]
      # )
      print(machine.execute("cat test-results.log")[1])
      print(machine.execute("grep 'Results Summary' -A 8 test-results.log")[1])

      # These tools are still missing:
      # Missing util(s): devname2devid mmap_libaio fio pamtester quotaon umask wait setenforce
      print(machine.execute("grep 'Missing util' test-results.log")[1])

      # Test results can be found in /var/tmp/test_results/<DATETIME>
    '';
})
