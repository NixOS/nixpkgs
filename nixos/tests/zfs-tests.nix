let
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

  tests = [
    # 00:07
    "chattr"
    # 01:47
    "checksum"
    # 01:00
    #"deadman" # disabled because it gives an error
    # 00:04
    "devices"
    # 00:02
    "fallocate"
    # 01:03
    "snapshot"
    # 00:02
    "tmpfile"
    # 00:22
    "upgrade"
    # 00:58
    "userquota"
    # 04:51
    "zdb"
    # 00:43
    "zfs"
    # 00:04
    "zfs_sysfs"
    # 04:54
    "zpool_add"
    # 03:06
    "zpool_reopen"
  ];

  mkTest = testname: (

    import ./make-test-python.nix ({ lib, pkgs, ... }:
      let
        zfsForTesting = pkgs.zfs;
      in
      {
        name = "zfs-tests-${testname}";
        meta = with lib.maintainers; {
          maintainers = [ mindavi ];
        };

        nodes.machine =
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
              virtualisation.cores = 6;

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

                pkgs.lvm2
              ];
              networking.hostId = "abcdef01";
            };

        testScript = ''
          start_all()
          machine.wait_for_unit("multi-user.target")
          print(machine.succeed("modprobe zfs", "zfs version", "id"))

          machine.succeed(
              "su - alice -- ${zfsForTesting.zfs_tests}/share/zfs/zfs-tests.sh -T ${testname} >> test-results.log",
          )
          # Show the last lines of the test results log.
          print(machine.execute("tail -n30 test-results.log")[1])

          print(machine.execute("cat test-results.log")[1])
          print(machine.execute("grep 'Results Summary' -A 8 test-results.log")[1])

          # These tools are still missing:
          # Missing util(s): devname2devid mmap_libaio fio pamtester quotaon umask wait setenforce
          print(machine.execute("grep 'Missing util' test-results.log")[1])

          # Test results can be found in /var/tmp/test_results/<DATETIME>
        '';
      })
  );
  lib = (import ../../. { }).lib;
in
lib.genAttrs tests mkTest

