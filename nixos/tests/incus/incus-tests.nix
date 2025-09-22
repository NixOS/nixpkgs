import ../make-test-python.nix (
  {
    pkgs,
    lib,

    lts ? true,

    allTests ? false,

    appArmor ? false,
    featureUser ? allTests,
    initLegacy ? true,
    initSystemd ? true,
    instanceContainer ? allTests,
    instanceVm ? allTests,
    networkOvs ? allTests,
    storageLvm ? allTests,
    storageZfs ? allTests,
    ...
  }:

  let
    releases =
      init:
      import ../../release.nix {
        configuration = {
          # Building documentation makes the test unnecessarily take a longer time:
          documentation.enable = lib.mkForce false;

          boot.initrd.systemd.enable = init == "systemd";

          # Arbitrary sysctl modification to ensure containers can update sysctl
          boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
        };
      };

    images = init: {
      container = {
        metadata =
          (releases init).incusContainerMeta.${pkgs.stdenv.hostPlatform.system}
          + "/tarball/nixos-image-lxc-*-${pkgs.stdenv.hostPlatform.system}.tar.xz";

        rootfs =
          (releases init).incusContainerImage.${pkgs.stdenv.hostPlatform.system}
          + "/nixos-lxc-image-${pkgs.stdenv.hostPlatform.system}.squashfs";
      };

      virtual-machine = {
        metadata =
          (releases init).incusVirtualMachineImageMeta.${pkgs.stdenv.hostPlatform.system} + "/*/*.tar.xz";
        disk = (releases init).incusVirtualMachineImage.${pkgs.stdenv.hostPlatform.system} + "/nixos.qcow2";
      };
    };

    initVariants = lib.optionals initLegacy [ "legacy" ] ++ lib.optionals initSystemd [ "systemd" ];

    canTestVm = instanceVm && pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64;
  in
  {
    name = "incus" + lib.optionalString lts "-lts";

    meta = {
      maintainers = lib.teams.lxc.members;
    };

    nodes.machine = {
      virtualisation = {
        cores = 2;
        memorySize = 2048;
        diskSize = 12 * 1024;
        emptyDiskImages = [
          # vdb for zfs
          2048
          # vdc for lvm
          2048
        ];

        incus = {
          enable = true;
          package = if lts then pkgs.incus-lts else pkgs.incus;

          preseed = {
            networks = [
              {
                name = "incusbr0";
                type = "bridge";
                config = {
                  "ipv4.address" = "10.0.10.1/24";
                  "ipv4.nat" = "true";
                };
              }
            ]
            ++ lib.optionals networkOvs [
              {
                name = "ovsbr0";
                type = "bridge";
                config = {
                  "bridge.driver" = "openvswitch";
                  "ipv4.address" = "10.0.20.1/24";
                  "ipv4.nat" = "true";
                };
              }
            ];
            profiles = [
              {
                name = "default";
                devices = {
                  eth0 = {
                    name = "eth0";
                    network = "incusbr0";
                    type = "nic";
                  };
                  root = {
                    path = "/";
                    pool = "default";
                    size = "35GiB";
                    type = "disk";
                  };
                };
              }
            ];
            storage_pools = [
              {
                name = "default";
                driver = "dir";
              }
            ];
          };
        };

        vswitch.enable = networkOvs;
      };

      boot.supportedFilesystems = lib.optionals storageZfs [ "zfs" ];
      boot.zfs.forceImportRoot = false;

      environment.systemPackages = [ pkgs.parted ];

      networking.hostId = "01234567";
      networking.firewall.trustedInterfaces = [ "incusbr0" ];

      security.apparmor.enable = appArmor;
      services.dbus.apparmor = (if appArmor then "enabled" else "disabled");

      services.lvm = {
        boot.thin.enable = storageLvm;
        dmeventd.enable = storageLvm;
      };

      networking.nftables.enable = true;

      users.users.testuser = {
        isNormalUser = true;
        shell = pkgs.bashInteractive;
        group = "incus";
        uid = 1000;
      };
    };

    testScript = # python
    ''
      import json

      def wait_for_instance(name: str, project: str = "default"):
          machine.wait_until_succeeds(f"incus exec {name} --disable-stdin --force-interactive --project {project} -- /run/current-system/sw/bin/systemctl is-system-running")


      def wait_incus_exec_success(name: str, command: str, timeout: int = 900, project: str = "default"):
          def check_command(_) -> bool:
              status, _ = machine.execute(f"incus exec {name} --disable-stdin --force-interactive --project {project} -- {command}")
              return status == 0

          with machine.nested(f"Waiting for successful exec: {command}"):
            retry(check_command, timeout)


      def set_config(name: str, config: str, restart: bool = False, unset: bool = False):
          if restart:
              machine.succeed(f"incus stop {name}")

          if unset:
            machine.succeed(f"incus config unset {name} {config}")
          else:
            machine.succeed(f"incus config set {name} {config}")

          if restart:
              machine.succeed(f"incus start {name}")
              wait_for_instance(name)
          else:
              # give a moment to settle
              machine.sleep(1)


      def cleanup():
          # avoid conflict between preseed and cleanup operations
          machine.execute("systemctl kill incus-preseed.service")

          instances = json.loads(machine.succeed("incus list --format json --all-projects"))
          with subtest("Stopping all running instances"):
              for instance in [a for a in instances if a['status'] == 'Running']:
                  machine.execute(f"incus stop --force {instance['name']} --project {instance['project']}")
                  machine.execute(f"incus delete --force {instance['name']} --project {instance['project']}")


      def check_sysctl(name: str):
          with subtest("systemd sysctl settings are applied"):
              machine.succeed(f"incus exec {name} -- systemctl status systemd-sysctl")
              sysctl = machine.succeed(f"incus exec {name} -- sysctl net.ipv4.ip_forward").strip().split(" ")[-1]
              assert "1" == sysctl, f"systemd-sysctl configuration not correctly applied, {sysctl} != 1"


      with subtest("Wait for startup"):
          machine.wait_for_unit("incus.service")
          machine.wait_for_unit("incus-preseed.service")


      with subtest("Verify preseed resources created"):
          machine.succeed("incus profile show default")
          machine.succeed("incus network info incusbr0")
          machine.succeed("incus storage show default")

    ''
    + lib.optionalString appArmor ''
      with subtest("Verify AppArmor service is started without issue"):
          # restart AppArmor service since the Incus AppArmor folders are
          # created after AA service is started
          machine.systemctl("restart apparmor.service")
          machine.succeed("systemctl --no-pager -l status apparmor.service")
          machine.wait_for_unit("apparmor.service")
    ''
    + lib.optionalString instanceContainer (
      lib.foldl (
        acc: variant:
        acc
        # python
        + ''
          metadata = "${(images variant).container.metadata}"
          rootfs = "${(images variant).container.rootfs}"
          alias = "nixos/container/${variant}"
          variant = "${variant}"

          with subtest("container image can be imported"):
              machine.succeed(f"incus image import {metadata} {rootfs} --alias {alias}")


          with subtest("container can be launched and managed"):
              machine.succeed(f"incus launch {alias} container-{variant}1")
              wait_for_instance(f"container-{variant}1")


          with subtest("container mounts lxcfs overlays"):
              machine.succeed(f"incus exec container-{variant}1 mount | grep 'lxcfs on /proc/cpuinfo type fuse.lxcfs'")
              machine.succeed(f"incus exec container-{variant}1 mount | grep 'lxcfs on /proc/meminfo type fuse.lxcfs'")


          with subtest("container CPU limits can be managed"):
              set_config(f"container-{variant}1", "limits.cpu 1", restart=True)
              wait_incus_exec_success(f"container-{variant}1", "nproc | grep '^1$'", timeout=90)


          with subtest("container CPU limits can be hotplug changed"):
              set_config(f"container-{variant}1", "limits.cpu 2")
              wait_incus_exec_success(f"container-{variant}1", "nproc | grep '^2$'", timeout=90)


          with subtest("container memory limits can be managed"):
              set_config(f"container-{variant}1", "limits.memory 128MB", restart=True)
              wait_incus_exec_success(f"container-{variant}1", "grep 'MemTotal:[[:space:]]*125000 kB' /proc/meminfo", timeout=90)


          with subtest("container memory limits can be hotplug changed"):
              set_config(f"container-{variant}1", "limits.memory 256MB")
              wait_incus_exec_success(f"container-{variant}1", "grep 'MemTotal:[[:space:]]*250000 kB' /proc/meminfo", timeout=90)


          with subtest("container software tpm can be configured"):
              machine.succeed(f"incus config device add container-{variant}1 vtpm tpm path=/dev/tpm0 pathrm=/dev/tpmrm0")
              machine.succeed(f"incus exec container-{variant}1 -- test -e /dev/tpm0")
              machine.succeed(f"incus exec container-{variant}1 -- test -e /dev/tpmrm0")
              machine.succeed(f"incus config device remove container-{variant}1 vtpm")
              machine.fail(f"incus exec container-{variant}1 -- test -e /dev/tpm0")


          with subtest("container lxc-generator compatibility"):
              with subtest("lxc-container generator configures plain container"):
                  # default container is plain
                  machine.succeed(f"incus exec container-{variant}1 test -- -e /run/systemd/system/service.d/zzz-lxc-service.conf")

                  check_sysctl(f"container-{variant}1")

              with subtest("lxc-container generator configures nested container"):
                  set_config(f"container-{variant}1", "security.nesting=true", restart=True)

                  machine.fail(f"incus exec container-{variant}1 test -- -e /run/systemd/system/service.d/zzz-lxc-service.conf")
                  target = machine.succeed(f"incus exec container-{variant}1 readlink -- -f /run/systemd/system/systemd-binfmt.service").strip()
                  assert target == "/dev/null", "lxc generator did not correctly mask /run/systemd/system/systemd-binfmt.service"

                  check_sysctl(f"container-{variant}1")

              with subtest("lxc-container generator configures privileged container"):
                  # Create a new instance for a clean state
                  machine.succeed(f"incus launch {alias} container-{variant}2")
                  wait_for_instance(f"container-{variant}2")

                  machine.succeed(f"incus exec container-{variant}2 test -- -e /run/systemd/system/service.d/zzz-lxc-service.conf")

                  check_sysctl(f"container-{variant}2")

          with subtest("container supports per-instance lxcfs"):
              machine.succeed(f"incus stop container-{variant}1")
              machine.fail(f"pgrep -a lxcfs | grep 'incus/devices/container-{variant}1/lxcfs'")

              machine.succeed("incus config set instances.lxcfs.per_instance=true")

              machine.succeed(f"incus start container-{variant}1")
              wait_for_instance(f"container-{variant}1")
              machine.succeed(f"pgrep -a lxcfs | grep 'incus/devices/container-{variant}1/lxcfs'")


          with subtest("container can successfully restart"):
              machine.succeed(f"incus restart container-{variant}1")
              wait_for_instance(f"container-{variant}1")


          with subtest("container remains running when softDaemonRestart is enabled and service is stopped"):
              pid = machine.succeed(f"incus info container-{variant}1 | grep 'PID'").split(":")[1].strip()
              machine.succeed(f"ps {pid}")
              machine.succeed("systemctl stop incus")
              machine.succeed(f"ps {pid}")
              machine.succeed("systemctl start incus")

              with subtest("containers stop with incus-startup.service"):
                  pid = machine.succeed(f"incus info container-{variant}1 | grep 'PID'").split(":")[1].strip()
                  machine.succeed(f"ps {pid}")
                  machine.succeed("systemctl stop incus-startup.service")
                  machine.wait_until_fails(f"ps {pid}", timeout=120)
                  machine.succeed("systemctl start incus-startup.service")


          cleanup()
        ''
      ) "" initVariants
    )
    + lib.optionalString canTestVm (
      (lib.foldl (
        acc: variant:
        acc
        # python
        + ''
          metadata = "${(images variant).virtual-machine.metadata}"
          disk = "${(images variant).virtual-machine.disk}"
          alias = "nixos/virtual-machine/${variant}"
          variant = "${variant}"

          with subtest("virtual-machine image can be imported"):
              machine.succeed(f"incus image import {metadata} {disk} --alias {alias}")


          with subtest("virtual-machine can be created"):
              machine.succeed(f"incus create {alias} vm-{variant}1 --vm --config limits.memory=512MB --config security.secureboot=false")


          with subtest("virtual-machine software tpm can be configured"):
              machine.succeed(f"incus config device add vm-{variant}1 vtpm tpm path=/dev/tpm0")


          with subtest("virtual-machine can be launched and become available"):
              machine.succeed(f"incus start vm-{variant}1")
              wait_for_instance(f"vm-{variant}1")


          with subtest("virtual-machine incus-agent is started"):
              machine.succeed(f"incus exec vm-{variant}1 systemctl is-active incus-agent")


          with subtest("virtual-machine incus-agent has a valid path"):
              machine.succeed(f"incus exec vm-{variant}1 -- bash -c 'true'")


          with subtest("virtual-machine CPU limits can be managed"):
              set_config(f"vm-{variant}1", "limits.cpu 1", restart=True)
              wait_incus_exec_success(f"vm-{variant}1", "nproc | grep '^1$'", timeout=90)


          with subtest("virtual-machine CPU limits can be hotplug changed"):
              set_config(f"vm-{variant}1", "limits.cpu 2")
              wait_incus_exec_success(f"vm-{variant}1", "nproc | grep '^2$'", timeout=90)


          with subtest("virtual-machine can successfully restart"):
              machine.succeed(f"incus restart vm-{variant}1")
              wait_for_instance(f"vm-{variant}1")


          with subtest("virtual-machine remains running when softDaemonRestart is enabled and service is stopped"):
              pid = machine.succeed(f"incus info vm-{variant}1 | grep 'PID'").split(":")[1].strip()
              machine.succeed(f"ps {pid}")
              machine.succeed("systemctl stop incus")
              machine.succeed(f"ps {pid}")
              machine.succeed("systemctl start incus")


              with subtest("virtual-machines stop with incus-startup.service"):
                  pid = machine.succeed(f"incus info vm-{variant}1 | grep 'PID'").split(":")[1].strip()
                  machine.succeed(f"ps {pid}")
                  machine.succeed("systemctl stop incus-startup.service")
                  machine.wait_until_fails(f"ps {pid}", timeout=120)
                  machine.succeed("systemctl start incus-startup.service")


          cleanup()
        ''
      ) "" initVariants)
      +
        # python
        ''
          with subtest("virtual-machine can launch CSM (BIOS)"):
              machine.succeed("incus init csm --vm --empty -c security.csm=true -c security.secureboot=false")
              machine.succeed("incus start csm")


          cleanup()
        ''
    )
    +
      lib.optionalString featureUser # python
        ''
          with subtest("incus-user allows restricted access for users"):
              machine.fail("incus project show user-1000")
              machine.succeed("su - testuser bash -c 'incus list'")
              # a project is created dynamically for the user
              machine.succeed("incus project show user-1000")
              # users shouldn't be able to list storage pools
              machine.fail("su - testuser bash -c 'incus storage list'")


          with subtest("incus-user allows users to launch instances"):
              machine.succeed("su - testuser bash -c 'incus image import ${(images "systemd").container.metadata} ${(images "systemd").container.rootfs} --alias nixos'")
              machine.succeed("su - testuser bash -c 'incus launch nixos instance2'")
              wait_for_instance("instance2", "user-1000")

          cleanup()
        ''
    +
      lib.optionalString networkOvs # python
        ''
          with subtest("Verify openvswitch bridge"):
              machine.succeed("incus network info ovsbr0")


          with subtest("Verify openvswitch bridge"):
              machine.succeed("ovs-vsctl br-exists ovsbr0")
        ''

    +
      lib.optionalString storageZfs # python
        ''
          with subtest("Verify zfs pool created and usable"):
              machine.succeed(
                  "zpool status",
                  "parted --script /dev/vdb mklabel gpt",
                  "zpool create zfs_pool /dev/vdb",
              )

              machine.succeed("incus storage create zfs_pool zfs source=zfs_pool/incus")
              machine.succeed("zfs list zfs_pool/incus")

              machine.succeed("incus storage volume create zfs_pool test_fs --type filesystem")
              machine.succeed("incus storage volume create zfs_pool test_vol --type block")

              machine.succeed("incus storage show zfs_pool")
              machine.succeed("incus storage volume list zfs_pool")
              machine.succeed("incus storage volume show zfs_pool test_fs")
              machine.succeed("incus storage volume show zfs_pool test_vol")

              machine.succeed("incus create zfs1 --empty --storage zfs_pool")
              machine.succeed("incus list zfs1")
        ''

    +
      lib.optionalString storageLvm # python
        ''
          with subtest("Verify lvm pool created and usable"):
              machine.succeed("incus storage create lvm_pool lvm source=/dev/vdc lvm.vg_name=incus_pool")
              machine.succeed("vgs incus_pool")

              machine.succeed("incus storage volume create lvm_pool test_fs --type filesystem")
              machine.succeed("incus storage volume create lvm_pool test_vol --type block")

              machine.succeed("incus storage show lvm_pool")

              machine.succeed("incus storage volume list lvm_pool")
              machine.succeed("incus storage volume show lvm_pool test_fs")
              machine.succeed("incus storage volume show lvm_pool test_vol")

              machine.succeed("incus create lvm1 --empty --storage lvm_pool")
              machine.succeed("incus list lvm1")
        '';
  }
)
