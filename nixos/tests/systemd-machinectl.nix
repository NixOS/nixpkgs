{ pkgs, lib, ... }:
let
  evalConfig =
    module:
    (import ../lib/eval-config.nix {
      system = null;
      modules = [ module ];
    }).config.system.build.toplevel;

  common =
    { config, ... }:
    {
      imports = [ ../modules/profiles/minimal.nix ];

      system.stateVersion = config.system.nixos.release;

      nixpkgs.pkgs = pkgs;
    };

  profile-host-nspawn = {
    # use networkd to obtain systemd network setup
    networking.useNetworkd = true;

    networking.firewall.extraCommands = ''
      # open DHCP for nspawn interfaces
      ${pkgs.iptables}/bin/iptables -A nixos-fw -i ve-+ -p udp -m udp --dport 67 -j nixos-fw-accept
    '';
  };

  # improvement: move following profile to ../modules/profiles/nspawn-guest.nix
  profile-guest-nspawn = {
    # We re-use the NixOS container option ...
    boot.isNspawnContainer = true;
    # ... and revert unwanted defaults
    networking.useHostResolvConf = false;

    # systemd-nspawn expects /sbin/init
    boot.loader.initScript.enable = true;

    # use networkd to obtain systemd network setup
    networking.useNetworkd = true;
  };

  profile-host-vmspawn =
    { config, pkgs, ... }:
    {
      # use networkd to obtain systemd network setup
      networking.useNetworkd = true;

      networking.firewall.extraCommands = ''
        # open DHCP for vmspawn interfaces
        ${pkgs.iptables}/bin/iptables -A nixos-fw -i vt-+ -p udp -m udp --dport 67 -j nixos-fw-accept
      '';

      environment.systemPackages =
        let
          # improvement: following wrapper should be moved to pkgs
          vmspawn-wrapped =
            pkgs.runCommand "systemd-vmspawn-wrapped" { nativeBuildInputs = [ pkgs.makeWrapper ]; }
              ''
                makeWrapper ${config.systemd.package}/bin/systemd-vmspawn $out/bin/systemd-vmspawn-wrapped \
                  --prefix PATH : ${
                    lib.makeBinPath [
                      pkgs.qemu
                      pkgs.virtiofsd
                      pkgs.openssh # ssh-keygen
                    ]
                  } \
                  --prefix XDG_CONFIG_HOME : ${pkgs.qemu}/share
              '';
        in
        [ vmspawn-wrapped ];
    };

  # improvement: move following profile to ../modules/profiles/vmspawn-guest.nix
  profile-guest-vmspawn = {
    imports = [ ../modules/profiles/qemu-guest.nix ];
    # improvement: move following configuration to qemu-guest.nix
    boot.initrd.availableKernelModules = [
      "virtiofs"
    ];

    boot.initrd.systemd.enable = true;
    # root is defined by systemd-vmspawn
    boot.initrd.systemd.root = null;

    boot.loader.grub.enable = false;

    # use networkd to obtain systemd network setup
    networking.useNetworkd = true;
  };

  container = {
    imports = [
      common
      profile-guest-nspawn
    ];
  };

  containerSystem = evalConfig container;

  containerName = "container";
  containerRoot = "/var/lib/machines/${containerName}";

  containerTarball = pkgs.callPackage ../lib/make-system-tarball.nix {
    storeContents = [
      {
        object = containerSystem;
        symlink = "/nix/var/nix/profiles/system";
      }
    ];

    contents = [
      {
        source = containerSystem + "/etc/os-release";
        target = "/etc/os-release";
      }
      {
        source = containerSystem + "/init";
        target = "/sbin/init";
      }
    ];
  };

  vm = {
    imports = [
      common
      profile-guest-vmspawn
    ];

    services.openssh.enable = true;
  };
  vmSystem = evalConfig vm;

  vmShared = {
    imports = [ vm ];

    fileSystems."/nix/store" = {
      device = "mnt0";
      fsType = "virtiofs";
      neededForBoot = true;
    };
  };
  vmSharedSystem = evalConfig vmShared;
in
{
  name = "systemd-machinectl";
  meta.maintainers = with lib.maintainers; [ ck3d ];

  nodes.machine =
    {
      lib,
      ...
    }:
    {
      imports = [
        profile-host-nspawn
        profile-host-vmspawn
      ];

      # do not try to access cache.nixos.org
      nix.settings.substituters = lib.mkForce [ ];

      # auto-start container
      systemd.targets.machines.wants = [ "systemd-nspawn@${containerName}.service" ];

      virtualisation.additionalPaths = [
        containerSystem
        containerTarball
        vmSystem
        vmSharedSystem
      ];

      virtualisation.diskSize = 2048;

      systemd.tmpfiles.rules = [
        "d /var/lib/machines/shared-decl 0755 root root - -"
      ];
      systemd.nspawn.shared-decl = {
        execConfig = {
          Boot = false;
          Parameters = "${containerSystem}/init";
        };
        filesConfig = {
          BindReadOnly = "/nix/store";
        };
      };

      systemd.nspawn.${containerName} = {
        filesConfig = {
          # workaround to fix kernel namespaces; needed for Nix sandbox
          # https://github.com/systemd/systemd/issues/27994#issuecomment-1704005670
          Bind = "/proc:/run/proc";
        };
      };

      systemd.services."systemd-nspawn@${containerName}" = {
        serviceConfig.Environment = [
          # Disable tmpfs for /tmp
          "SYSTEMD_NSPAWN_TMPFS_TMP=0"
        ];
        overrideStrategy = "asDropin";
      };
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("default.target");
    # Workaround for nixos-install
    machine.succeed("chmod o+rx /var/lib/machines");

    with subtest("vm-shared"):
      machine.succeed("mkdir -p /var/lib/machines/vm-shared");
      # Start vm-shared
      machine.succeed("systemd-run systemd-vmspawn-wrapped --directory=/var/lib/machines/vm-shared --bind-ro=/nix/store --linux=${vmSharedSystem}/kernel --initrd=${vmSharedSystem}/initrd ${vmSharedSystem}/kernel-params init=${vmSharedSystem}/init")
      machine.wait_until_succeeds("machinectl status vm-shared");
      machine.wait_until_succeeds("eval $(machinectl show vm-shared --property=SSHPrivateKeyPath --property=SSHAddress) && ssh -i $SSHPrivateKeyPath $SSHAddress true")
      machine.succeed("machinectl stop vm-shared");

    with subtest("vm"):
      machine.succeed("mkdir -p /var/lib/machines/vm");
      # Install vm
      machine.succeed("nixos-install --root /var/lib/machines/vm --system ${vmSystem} --no-channel-copy --no-root-passwd");
      # Start vm
      machine.succeed("systemd-run systemd-vmspawn-wrapped --directory=/var/lib/machines/vm --linux=${vmSystem}/kernel --initrd=${vmSystem}/initrd ${vmSystem}/kernel-params init=${vmSystem}/init")
      machine.wait_until_succeeds("machinectl status vm");
      machine.wait_until_succeeds("eval $(machinectl show vm --property=SSHPrivateKeyPath --property=SSHAddress) && ssh -i $SSHPrivateKeyPath $SSHAddress true")
      machine.succeed("machinectl stop vm");

    # Test machinectl start stop of shared-decl
    machine.succeed("machinectl start shared-decl");
    machine.wait_until_succeeds("systemctl -M shared-decl is-active default.target");
    machine.succeed("machinectl stop shared-decl");

    machine.succeed("mkdir -p ${containerRoot}");

    # start container with shared nix store by using same arguments as for systemd-nspawn@.service
    machine.succeed("systemd-run systemd-nspawn --machine=${containerName} --network-veth -U --bind-ro=/nix/store ${containerSystem}/init")
    machine.wait_until_succeeds("systemctl -M ${containerName} is-active default.target");

    # Test machinectl stop
    machine.succeed("machinectl stop ${containerName}");

    # Install container
    machine.succeed("nixos-install --root ${containerRoot} --system ${containerSystem} --no-channel-copy --no-root-passwd");

    # Allow systemd-nspawn to apply user namespace on immutable files
    machine.succeed("chattr -i ${containerRoot}/var/empty");

    # Test machinectl start
    machine.succeed("machinectl start ${containerName}");
    machine.wait_until_succeeds("systemctl -M ${containerName} is-active default.target");

    # Test systemd-nspawn configured unified cgroup delegation
    # see also:
    # https://github.com/systemd/systemd/blob/main/docs/CGROUP_DELEGATION.md#three-different-tree-setups-
    machine.succeed('systemd-run --pty --wait -M ${containerName} /run/current-system/sw/bin/stat --format="%T" --file-system /sys/fs/cgroup > fstype')
    machine.succeed('test $(tr -d "\\r" < fstype) = cgroup2fs')

    # Test if systemd-nspawn provides a working environment for nix to build derivations
    # https://nixos.org/guides/nix-pills/07-working-derivation
    machine.succeed('systemd-run --pty --wait -M ${containerName} /run/current-system/sw/bin/nix-instantiate --expr \'derivation { name = "myname"; builder = "/bin/sh"; args = [ "-c" "echo foo > $out" ]; system = "${pkgs.stdenv.hostPlatform.system}"; }\' --add-root /tmp/drv')
    machine.succeed('systemd-run --pty --wait -M ${containerName} /run/current-system/sw/bin/nix-store --option substitute false --realize /tmp/drv')

    # Test nss_mymachines without nscd
    machine.succeed('LD_LIBRARY_PATH="/run/current-system/sw/lib" getent -s hosts:mymachines hosts ${containerName}');

    # Test nss_mymachines via nscd
    machine.succeed("getent hosts ${containerName}");

    # Test systemd-nspawn network configuration to container
    machine.succeed("networkctl --json=short status ve-${containerName} | ${pkgs.jq}/bin/jq -e '.OperationalState == \"routable\"'");

    # Test systemd-nspawn network configuration to host
    machine.succeed("machinectl shell ${containerName} /run/current-system/sw/bin/networkctl --json=short status host0 | ${pkgs.jq}/bin/jq -r '.OperationalState == \"routable\"'");

    # Test systemd-nspawn network configuration
    machine.succeed("ping -n -c 1 ${containerName}");

    # Test systemd-nspawn uses a user namespace
    machine.succeed("test $(machinectl status ${containerName} | grep 'ID Shift: ' | wc -l) = 1")

    # Test systemd-nspawn reboot
    machine.succeed("machinectl shell ${containerName} /run/current-system/sw/bin/reboot");
    machine.wait_until_succeeds("systemctl -M ${containerName} is-active default.target");

    # Test machinectl reboot
    machine.succeed("machinectl reboot ${containerName}");
    machine.wait_until_succeeds("systemctl -M ${containerName} is-active default.target");

    # Restart machine
    machine.shutdown()
    machine.start()
    machine.wait_for_unit("default.target");

    # Test auto-start
    machine.succeed("machinectl show ${containerName}")
    machine.wait_until_succeeds("systemctl -M ${containerName} is-active default.target");

    # Test machinectl stop
    machine.succeed("machinectl stop ${containerName}");
    machine.wait_until_succeeds("test $(systemctl is-active systemd-nspawn@${containerName}) = inactive");

    # Test tmpfs for /tmp
    machine.fail("mountpoint /tmp");

    # Show to to delete the container
    machine.succeed("chattr -i ${containerRoot}/var/empty");
    machine.succeed("rm -rf ${containerRoot}");

    # Test import tarball, start, stop and remove
    machine.succeed("machinectl import-tar ${containerTarball}/tarball/*.tar* ${containerName}");
    machine.succeed("machinectl start ${containerName}");
    machine.wait_until_succeeds("systemctl -M ${containerName} is-active default.target");
    machine.succeed("machinectl stop ${containerName}");
    machine.wait_until_succeeds("test $(systemctl is-active systemd-nspawn@${containerName}) = inactive");
    machine.succeed("machinectl remove ${containerName}");
  '';
}
