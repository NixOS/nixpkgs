{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; },
  systemdStage1 ? false
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let

  # The configuration to install.
  makeConfig = { bootLoader, grubDevice, grubIdentifier, grubUseEfi
               , extraConfig, forceGrubReinstallCount ? 0, flake ? false
               , clevisTest
               }:
    pkgs.writeText "configuration.nix" ''
      { config, lib, pkgs, modulesPath, ... }:

      { imports =
          [ ./hardware-configuration.nix
            ${if flake
              then "" # Still included, but via installer/flake.nix
              else "<nixpkgs/nixos/modules/testing/test-instrumentation.nix>"}
          ];

        networking.hostName = "thatworked";

        documentation.enable = false;

        # To ensure that we can rebuild the grub configuration on the nixos-rebuild
        system.extraDependencies = with pkgs; [ stdenvNoCC ];

        ${optionalString systemdStage1 "boot.initrd.systemd.enable = true;"}

        ${optionalString (bootLoader == "grub") ''
          boot.loader.grub.extraConfig = "serial; terminal_output serial";
          ${if grubUseEfi then ''
            boot.loader.grub.device = "nodev";
            boot.loader.grub.efiSupport = true;
            boot.loader.grub.efiInstallAsRemovable = true; # XXX: needed for OVMF?
          '' else ''
            boot.loader.grub.device = "${grubDevice}";
            boot.loader.grub.fsIdentifier = "${grubIdentifier}";
          ''}

          boot.loader.grub.configurationLimit = 100 + ${toString forceGrubReinstallCount};
        ''}

        ${optionalString (bootLoader == "systemd-boot") ''
          boot.loader.systemd-boot.enable = true;
        ''}

        boot.initrd.secrets."/etc/secret" = ./secret;

        ${optionalString clevisTest ''
          boot.kernelParams = [ "console=tty0" "ip=192.168.1.1:::255.255.255.0::eth1:none" ];
          boot.initrd = {
            availableKernelModules = [ "tpm_tis" ];
            clevis = { enable = true; useTang = true; };
            network.enable = true;
          };
          ''}

        users.users.alice = {
          isNormalUser = true;
          home = "/home/alice";
          description = "Alice Foobar";
        };

        hardware.enableAllFirmware = lib.mkForce false;

        ${replaceStrings ["\n"] ["\n  "] extraConfig}
      }
    '';


  # The test script boots a NixOS VM, installs NixOS on an empty hard
  # disk, and then reboot from the hard disk.  It's parameterized with
  # a test script fragment `createPartitions', which must create
  # partitions and filesystems.
  testScriptFun = { bootLoader, createPartitions, grubDevice, grubUseEfi, grubIdentifier
                  , postInstallCommands, preBootCommands, postBootCommands, extraConfig
                  , testSpecialisationConfig, testFlakeSwitch, clevisTest, clevisFallbackTest
                  }:
    let iface = "virtio";
        isEfi = bootLoader == "systemd-boot" || (bootLoader == "grub" && grubUseEfi);
        bios  = if pkgs.stdenv.isAarch64 then "QEMU_EFI.fd" else "OVMF.fd";
    in if !isEfi && !pkgs.stdenv.hostPlatform.isx86 then ''
      machine.succeed("true")
    '' else ''
      import subprocess
      tpm_folder = os.environ['NIX_BUILD_TOP']
      def assemble_qemu_flags():
          flags = "-cpu max"
          ${if (system == "x86_64-linux" || system == "i686-linux")
            then ''flags += " -m 1024"''
            else ''flags += " -m 768 -enable-kvm -machine virt,gic-version=host"''
          }
          ${optionalString clevisTest ''flags += f" -chardev socket,id=chrtpm,path={tpm_folder}/swtpm-sock -tpmdev emulator,id=tpm0,chardev=chrtpm -device tpm-tis,tpmdev=tpm0"''}
          ${optionalString clevisTest ''flags += " -device virtio-net-pci,netdev=vlan1,mac=52:54:00:12:11:02 -netdev vde,id=vlan1,sock=\"$QEMU_VDE_SOCKET_1\""''}
          return flags


      qemu_flags = {"qemuFlags": assemble_qemu_flags()}

      import os

      image_dir = machine.state_dir
      disk_image = os.path.join(image_dir, "machine.qcow2")

      hd_flags = {
          "hdaInterface": "${iface}",
          "hda": disk_image,
      }
      ${optionalString isEfi ''
        hd_flags.update(
            bios="${pkgs.OVMF.fd}/FV/${bios}"
        )''
      }
      default_flags = {**hd_flags, **qemu_flags}


      def create_machine_named(name):
          return create_machine({**default_flags, "name": name})

      class Tpm:
            def __init__(self):
                self.start()

            def start(self):
                self.proc = subprocess.Popen(["${pkgs.swtpm}/bin/swtpm",
                    "socket",
                    "--tpmstate", f"dir={tpm_folder}/swtpm",
                    "--ctrl", f"type=unixio,path={tpm_folder}/swtpm-sock",
                    "--tpm2"
                    ])

                # Check whether starting swtpm failed
                try:
                    exit_code = self.proc.wait(timeout=0.2)
                    if exit_code is not None and exit_code != 0:
                        raise Exception("failed to start swtpm")
                except subprocess.TimeoutExpired:
                    pass

            """Check whether the swtpm process exited due to an error"""
            def check(self):
                exit_code = self.proc.poll()
                if exit_code is not None and exit_code != 0:
                    raise Exception("swtpm process died")


      os.mkdir(f"{tpm_folder}/swtpm")
      tpm = Tpm()
      tpm.check()

      start_all()
      ${optionalString clevisTest ''
      tang.wait_for_unit("sockets.target")
      tang.systemctl("start network-online.target")
      tang.wait_for_unit("network-online.target")
      machine.systemctl("start network-online.target")
      machine.wait_for_unit("network-online.target")
      ''}
      machine.wait_for_unit("multi-user.target")


      with subtest("Assert readiness of login prompt"):
          machine.succeed("echo hello")

      with subtest("Wait for hard disks to appear in /dev"):
          machine.succeed("udevadm settle")

      ${createPartitions}

      with subtest("Create the NixOS configuration"):
          machine.succeed("nixos-generate-config --root /mnt")
          machine.succeed("cat /mnt/etc/nixos/hardware-configuration.nix >&2")
          machine.copy_from_host(
              "${ makeConfig {
                    inherit bootLoader grubDevice grubIdentifier
                            grubUseEfi extraConfig clevisTest;
                  }
              }",
              "/mnt/etc/nixos/configuration.nix",
          )
          machine.copy_from_host("${pkgs.writeText "secret" "secret"}", "/mnt/etc/nixos/secret")

      ${optionalString clevisTest ''
        with subtest("Create the Clevis secret with Tang"):
             machine.systemctl("start network-online.target")
             machine.wait_for_unit("network-online.target")
             machine.succeed('echo -n password | clevis encrypt sss \'{"t": 2, "pins": {"tpm2": {}, "tang": {"url": "http://192.168.1.2"}}}\' -y > /mnt/etc/nixos/clevis-secret.jwe')''}

      ${optionalString clevisFallbackTest ''
        with subtest("Shutdown Tang to check fallback to interactive prompt"):
            tang.shutdown()
      ''}

      with subtest("Perform the installation"):
          machine.succeed("nixos-install < /dev/null >&2")

      with subtest("Do it again to make sure it's idempotent"):
          machine.succeed("nixos-install < /dev/null >&2")

      with subtest("Check that we can build things in nixos-enter"):
          machine.succeed(
              """
              nixos-enter -- nix-build --option substitute false -E 'derivation {
                  name = "t";
                  builder = "/bin/sh";
                  args = ["-c" "echo nixos-enter build > $out"];
                  system = builtins.currentSystem;
                  preferLocalBuild = true;
              }'
              """
          )

      ${postInstallCommands}

      with subtest("Shutdown system after installation"):
          machine.succeed("umount -R /mnt")
          machine.succeed("sync")
          machine.shutdown()

      # Now see if we can boot the installation.
      machine = create_machine_named("boot-after-install")

      # For example to enter LUKS passphrase.
      ${preBootCommands}

      with subtest("Assert that /boot get mounted"):
          machine.wait_for_unit("local-fs.target")
          ${if bootLoader == "grub"
              then ''machine.succeed("test -e /boot/grub")''
              else ''machine.succeed("test -e /boot/loader/loader.conf")''
          }

      with subtest("Check whether /root has correct permissions"):
          assert "700" in machine.succeed("stat -c '%a' /root")

      with subtest("Assert swap device got activated"):
          # uncomment once https://bugs.freedesktop.org/show_bug.cgi?id=86930 is resolved
          machine.wait_for_unit("swap.target")
          machine.succeed("cat /proc/swaps | grep -q /dev")

      with subtest("Check that the store is in good shape"):
          machine.succeed("nix-store --verify --check-contents >&2")

      with subtest("Check whether the channel works"):
          machine.succeed("nix-env -iA nixos.procps >&2")
          assert ".nix-profile" in machine.succeed("type -tP ps | tee /dev/stderr")

      with subtest(
          "Check that the daemon works, and that non-root users can run builds "
          "(this will build a new profile generation through the daemon)"
      ):
          machine.succeed("su alice -l -c 'nix-env -iA nixos.procps' >&2")

      with subtest("Configure system with writable Nix store on next boot"):
          # we're not using copy_from_host here because the installer image
          # doesn't know about the host-guest sharing mechanism.
          machine.copy_from_host_via_shell(
              "${ makeConfig {
                    inherit bootLoader grubDevice grubIdentifier
                            grubUseEfi extraConfig clevisTest;
                    forceGrubReinstallCount = 1;
                  }
              }",
              "/etc/nixos/configuration.nix",
          )

      with subtest("Check whether nixos-rebuild works"):
          machine.succeed("nixos-rebuild switch >&2")

      # FIXME: Nix 2.4 broke nixos-option, someone has to fix it.
      # with subtest("Test nixos-option"):
      #     kernel_modules = machine.succeed("nixos-option boot.initrd.kernelModules")
      #     assert "virtio_console" in kernel_modules
      #     assert "List of modules" in kernel_modules
      #     assert "qemu-guest.nix" in kernel_modules

      machine.shutdown()

      # Check whether a writable store build works
      machine = create_machine_named("rebuild-switch")
      ${preBootCommands}
      machine.wait_for_unit("multi-user.target")

      # we're not using copy_from_host here because the installer image
      # doesn't know about the host-guest sharing mechanism.
      machine.copy_from_host_via_shell(
          "${ makeConfig {
                inherit bootLoader grubDevice grubIdentifier
                grubUseEfi extraConfig clevisTest;
                forceGrubReinstallCount = 2;
              }
          }",
          "/etc/nixos/configuration.nix",
      )
      machine.succeed("nixos-rebuild boot >&2")
      machine.shutdown()

      # And just to be sure, check that the machine still boots after
      # "nixos-rebuild switch".
      machine = create_machine_named("boot-after-rebuild-switch")
      ${preBootCommands}
      machine.wait_for_unit("network.target")

      # Sanity check, is it the configuration.nix we generated?
      hostname = machine.succeed("hostname").strip()
      assert hostname == "thatworked"

      ${postBootCommands}
      machine.shutdown()

      # Tests for validating clone configuration entries in grub menu
    ''
    + optionalString testSpecialisationConfig ''
      # Reboot Machine
      machine = create_machine_named("clone-default-config")
      ${preBootCommands}
      machine.wait_for_unit("multi-user.target")

      with subtest("Booted configuration name should be 'Home'"):
          # This is not the name that shows in the grub menu.
          # The default configuration is always shown as "Default"
          machine.succeed("cat /run/booted-system/configuration-name >&2")
          assert "Home" in machine.succeed("cat /run/booted-system/configuration-name")

      with subtest("We should **not** find a file named /etc/gitconfig"):
          machine.fail("test -e /etc/gitconfig")

      with subtest("Set grub to boot the second configuration"):
          machine.succeed("grub-reboot 1")

      ${postBootCommands}
      machine.shutdown()

      # Reboot Machine
      machine = create_machine_named("clone-alternate-config")
      ${preBootCommands}

      machine.wait_for_unit("multi-user.target")
      with subtest("Booted configuration name should be Work"):
          machine.succeed("cat /run/booted-system/configuration-name >&2")
          assert "Work" in machine.succeed("cat /run/booted-system/configuration-name")

      with subtest("We should find a file named /etc/gitconfig"):
          machine.succeed("test -e /etc/gitconfig")

      ${postBootCommands}
      machine.shutdown()
    ''
    + optionalString testFlakeSwitch ''
      ${preBootCommands}
      machine.start()

      with subtest("Configure system with flake"):
        # TODO: evaluate as user?
        machine.succeed("""
          mkdir /root/my-config
          mv /etc/nixos/hardware-configuration.nix /root/my-config/
          mv /etc/nixos/secret /root/my-config/
          rm /etc/nixos/configuration.nix
        """)
        machine.copy_from_host_via_shell(
          "${makeConfig {
               inherit bootLoader grubDevice grubIdentifier grubUseEfi extraConfig clevisTest;
               forceGrubReinstallCount = 1;
               flake = true;
            }}",
          "/root/my-config/configuration.nix",
        )
        machine.copy_from_host_via_shell(
          "${./installer/flake.nix}",
          "/root/my-config/flake.nix",
        )
        machine.succeed("""
          # for some reason the image does not have `pkgs.path`, so
          # we use readlink to find a Nixpkgs source.
          pkgs=$(readlink -f /nix/var/nix/profiles/per-user/root/channels)/nixos
          if ! [[ -e $pkgs/pkgs/top-level/default.nix ]]; then
            echo 1>&2 "$pkgs does not seem to be a nixpkgs source. Please fix the test so that pkgs points to a nixpkgs source.";
            exit 1;
          fi
          sed -e s^@nixpkgs@^$pkgs^ -i /root/my-config/flake.nix
        """)

      with subtest("Switch to flake based config"):
        machine.succeed("nixos-rebuild switch --flake /root/my-config#xyz")

      ${postBootCommands}
      machine.shutdown()

      ${preBootCommands}
      machine.start()

      machine.wait_for_unit("multi-user.target")

      with subtest("nix-channel command is not available anymore"):
        machine.succeed("! which nix-channel")

      # Note that the channel profile is still present on disk, but configured
      # not to be used.
      with subtest("builtins.nixPath is now empty"):
        machine.succeed("""
          [[ "[ ]" == "$(nix-instantiate builtins.nixPath --eval --expr)" ]]
        """)

      with subtest("<nixpkgs> does not resolve"):
        machine.succeed("""
          ! nix-instantiate '<nixpkgs>' --eval --expr
        """)

      with subtest("Evaluate flake config in fresh env without nix-channel"):
        machine.succeed("nixos-rebuild switch --flake /root/my-config#xyz")

      with subtest("Evaluate flake config in fresh env without channel profiles"):
        machine.succeed("""
          (
            exec 1>&2
            rm -v /root/.nix-channels
            rm -vrf ~/.nix-defexpr
            rm -vrf /nix/var/nix/profiles/per-user/root/channels*
          )
        """)
        machine.succeed("nixos-rebuild switch --flake /root/my-config#xyz")

      ${postBootCommands}
      machine.shutdown()
    '';


  makeInstallerTest = name:
    { createPartitions
    , postInstallCommands ? "", preBootCommands ? "", postBootCommands ? ""
    , extraConfig ? ""
    , extraInstallerConfig ? {}
    , bootLoader ? "grub" # either "grub" or "systemd-boot"
    , grubDevice ? "/dev/vda", grubIdentifier ? "uuid", grubUseEfi ? false
    , enableOCR ? false, meta ? {}
    , testSpecialisationConfig ? false
    , testFlakeSwitch ? false
    , clevisTest ? false
    , clevisFallbackTest ? false
    }:
    makeTest {
      inherit enableOCR;
      name = "installer-" + name;
      meta = {
        # put global maintainers here, individuals go into makeInstallerTest fkt call
        maintainers = (meta.maintainers or []);
      };
      nodes = {

        # The configuration of the machine used to run "nixos-install".
        machine = { pkgs, ... }: {
          imports = [
            ../modules/profiles/installation-device.nix
            ../modules/profiles/base.nix
            extraInstallerConfig
            ./common/auto-format-root-device.nix
          ];

          # In systemdStage1, also automatically format the device backing the
          # root filesystem.
          virtualisation.fileSystems."/".autoFormat = systemdStage1;

          # builds stuff in the VM, needs more juice
          virtualisation.diskSize = 8 * 1024;
          virtualisation.cores = 8;
          virtualisation.memorySize = 1536;

          boot.initrd.systemd.enable = systemdStage1;

          # Use a small /dev/vdb as the root disk for the
          # installer. This ensures the target disk (/dev/vda) is
          # the same during and after installation.
          virtualisation.emptyDiskImages = [ 512 ];
          virtualisation.rootDevice = "/dev/vdb";
          virtualisation.bootLoaderDevice = "/dev/vda";
          virtualisation.qemu.diskInterface = "virtio";
          virtualisation.qemu.options = mkIf (clevisTest) [
            "-chardev socket,id=chrtpm,path=$NIX_BUILD_TOP/swtpm-sock"
            "-tpmdev emulator,id=tpm0,chardev=chrtpm"
            "-device tpm-tis,tpmdev=tpm0"
          ];
          # We don't want to have any networking in the guest apart from the clevis tests.
          virtualisation.vlans = mkIf (!clevisTest) [];

          boot.loader.systemd-boot.enable = mkIf (bootLoader == "systemd-boot") true;

          hardware.enableAllFirmware = mkForce false;

          # The test cannot access the network, so any packages we
          # need must be included in the VM.
          system.extraDependencies = with pkgs; [
            bintools
            brotli
            brotli.dev
            brotli.lib
            desktop-file-utils
            docbook5
            docbook_xsl_ns
            kbd.dev
            kmod.dev
            libarchive.dev
            libxml2.bin
            libxslt.bin
            nixos-artwork.wallpapers.simple-dark-gray-bottom
            ntp
            perlPackages.ListCompare
            perlPackages.XMLLibXML
            # make-options-doc/default.nix
            (python3.withPackages (p: [ p.mistune ]))
            shared-mime-info
            sudo
            texinfo
            unionfs-fuse
            xorg.lndir

            # add curl so that rather than seeing the test attempt to download
            # curl's tarball, we see what it's trying to download
            curl
          ]
          ++ optionals (bootLoader == "grub") (let
            zfsSupport = lib.any (x: x == "zfs")
              (extraInstallerConfig.boot.supportedFilesystems or []);
          in [
            (pkgs.grub2.override { inherit zfsSupport; })
            (pkgs.grub2_efi.override { inherit zfsSupport; })
          ]) ++ optionals clevisTest [ pkgs.klibc ];

          nix.settings = {
            substituters = mkForce [];
            hashed-mirrors = null;
            connect-timeout = 1;
          };
        };

      } // optionalAttrs clevisTest {
        tang = {
          services.tang = {
            enable = true;
            listenStream = [ "80" ];
            ipAddressAllow = [ "192.168.1.0/24" ];
          };
          networking.firewall.allowedTCPPorts = [ 80 ];
        };
      };

      testScript = testScriptFun {
        inherit bootLoader createPartitions postInstallCommands preBootCommands postBootCommands
                grubDevice grubIdentifier grubUseEfi extraConfig
                testSpecialisationConfig testFlakeSwitch clevisTest clevisFallbackTest;
      };
    };

    makeLuksRootTest = name: luksFormatOpts: makeInstallerTest name {
      createPartitions = ''
        machine.succeed(
            "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
            + " mkpart primary ext2 1M 100MB"  # /boot
            + " mkpart primary linux-swap 100M 1024M"
            + " mkpart primary 1024M -1s",  # LUKS
            "udevadm settle",
            "mkswap /dev/vda2 -L swap",
            "swapon -L swap",
            "modprobe dm_mod dm_crypt",
            "echo -n supersecret | cryptsetup luksFormat ${luksFormatOpts} -q /dev/vda3 -",
            "echo -n supersecret | cryptsetup luksOpen --key-file - /dev/vda3 cryptroot",
            "mkfs.ext3 -L nixos /dev/mapper/cryptroot",
            "mount LABEL=nixos /mnt",
            "mkfs.ext3 -L boot /dev/vda1",
            "mkdir -p /mnt/boot",
            "mount LABEL=boot /mnt/boot",
        )
      '';
      extraConfig = ''
        boot.kernelParams = lib.mkAfter [ "console=tty0" ];
      '';
      enableOCR = true;
      preBootCommands = ''
        machine.start()
        machine.wait_for_text("[Pp]assphrase for")
        machine.send_chars("supersecret\n")
      '';
    };

  # The (almost) simplest partitioning scheme: a swap partition and
  # one big filesystem partition.
  simple-test-config = {
    createPartitions = ''
      machine.succeed(
          "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
          + " mkpart primary linux-swap 1M 1024M"
          + " mkpart primary ext2 1024M -1s",
          "udevadm settle",
          "mkswap /dev/vda1 -L swap",
          "swapon -L swap",
          "mkfs.ext3 -L nixos /dev/vda2",
          "mount LABEL=nixos /mnt",
      )
    '';
  };

  simple-test-config-flake = simple-test-config // {
    testFlakeSwitch = true;
  };

  simple-uefi-grub-config = {
    createPartitions = ''
      machine.succeed(
          "flock /dev/vda parted --script /dev/vda -- mklabel gpt"
          + " mkpart ESP fat32 1M 100MiB"  # /boot
          + " set 1 boot on"
          + " mkpart primary linux-swap 100MiB 1024MiB"
          + " mkpart primary ext2 1024MiB -1MiB",  # /
          "udevadm settle",
          "mkswap /dev/vda2 -L swap",
          "swapon -L swap",
          "mkfs.ext3 -L nixos /dev/vda3",
          "mount LABEL=nixos /mnt",
          "mkfs.vfat -n BOOT /dev/vda1",
          "mkdir -p /mnt/boot",
          "mount LABEL=BOOT /mnt/boot",
      )
    '';
    bootLoader = "grub";
    grubUseEfi = true;
  };

  specialisation-test-extraconfig = {
    extraConfig = ''
      environment.systemPackages = [ pkgs.grub2 ];
      boot.loader.grub.configurationName = "Home";
      specialisation.work.configuration = {
        boot.loader.grub.configurationName = lib.mkForce "Work";

        environment.etc = {
          "gitconfig".text = "
            [core]
              gitproxy = none for work.com
              ";
        };
      };
    '';
    testSpecialisationConfig = true;
  };
  # disable zfs so we can support latest kernel if needed
  no-zfs-module = {
    nixpkgs.overlays = [(final: super: {
      zfs = super.zfs.overrideAttrs(_: {meta.platforms = [];});}
    )];
  };

 mkClevisBcachefsTest = { fallback ? false }: makeInstallerTest "clevis-bcachefs${optionalString fallback "-fallback"}" {
    clevisTest = true;
    clevisFallbackTest = fallback;
    enableOCR = fallback;
    extraInstallerConfig = {
      imports = [ no-zfs-module ];
      boot.supportedFilesystems = [ "bcachefs" ];
      environment.systemPackages = with pkgs; [ keyutils clevis ];
    };
    createPartitions = ''
      machine.succeed(
        "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
        + " mkpart primary ext2 1M 100MB"
        + " mkpart primary linux-swap 100M 1024M"
        + " mkpart primary 1024M -1s",
        "udevadm settle",
        "mkswap /dev/vda2 -L swap",
        "swapon -L swap",
        "keyctl link @u @s",
        "echo -n password | mkfs.bcachefs -L root --encrypted /dev/vda3",
        "echo -n password | bcachefs unlock /dev/vda3",
        "echo -n password | mount -t bcachefs /dev/vda3 /mnt",
        "mkfs.ext3 -L boot /dev/vda1",
        "mkdir -p /mnt/boot",
        "mount LABEL=boot /mnt/boot",
        "udevadm settle")
    '';
    extraConfig = ''
      boot.initrd.clevis.devices."/dev/vda3".secretFile = "/etc/nixos/clevis-secret.jwe";

      # We override what nixos-generate-config has generated because we do
      # not know the UUID in advance.
      fileSystems."/" = lib.mkForce { device = "/dev/vda3"; fsType = "bcachefs"; };
    '';
    preBootCommands = ''
      tpm = Tpm()
      tpm.check()
    '' + optionalString fallback ''
      machine.start()
      machine.wait_for_text("enter passphrase for")
      machine.send_chars("password\n")
    '';
  };

  mkClevisLuksTest = { fallback ? false }: makeInstallerTest "clevis-luks${optionalString fallback "-fallback"}" {
    clevisTest = true;
    clevisFallbackTest = fallback;
    enableOCR = fallback;
    extraInstallerConfig = {
      environment.systemPackages = with pkgs; [ clevis ];
    };
    createPartitions = ''
      machine.succeed(
        "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
        + " mkpart primary ext2 1M 100MB"
        + " mkpart primary linux-swap 100M 1024M"
        + " mkpart primary 1024M -1s",
        "udevadm settle",
        "mkswap /dev/vda2 -L swap",
        "swapon -L swap",
        "modprobe dm_mod dm_crypt",
        "echo -n password | cryptsetup luksFormat -q /dev/vda3 -",
        "echo -n password | cryptsetup luksOpen --key-file - /dev/vda3 crypt-root",
        "mkfs.ext3 -L nixos /dev/mapper/crypt-root",
        "mount LABEL=nixos /mnt",
        "mkfs.ext3 -L boot /dev/vda1",
        "mkdir -p /mnt/boot",
        "mount LABEL=boot /mnt/boot",
        "udevadm settle")
    '';
    extraConfig = ''
      boot.initrd.clevis.devices."crypt-root".secretFile = "/etc/nixos/clevis-secret.jwe";
    '';
    preBootCommands = ''
      tpm = Tpm()
      tpm.check()
    '' + optionalString fallback ''
      machine.start()
      ${if systemdStage1 then ''
      machine.wait_for_text("Please enter")
      '' else ''
      machine.wait_for_text("Passphrase for")
      ''}
      machine.send_chars("password\n")
    '';
  };

  mkClevisZfsTest = { fallback ? false }: makeInstallerTest "clevis-zfs${optionalString fallback "-fallback"}" {
    clevisTest = true;
    clevisFallbackTest = fallback;
    enableOCR = fallback;
    extraInstallerConfig = {
      boot.supportedFilesystems = [ "zfs" ];
      environment.systemPackages = with pkgs; [ clevis ];
    };
    createPartitions = ''
      machine.succeed(
        "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
        + " mkpart primary ext2 1M 100MB"
        + " mkpart primary linux-swap 100M 1024M"
        + " mkpart primary 1024M -1s",
        "udevadm settle",
        "mkswap /dev/vda2 -L swap",
        "swapon -L swap",
        "zpool create -O mountpoint=legacy rpool /dev/vda3",
        "echo -n password | zfs create"
        + " -o encryption=aes-256-gcm -o keyformat=passphrase rpool/root",
        "mount -t zfs rpool/root /mnt",
        "mkfs.ext3 -L boot /dev/vda1",
        "mkdir -p /mnt/boot",
        "mount LABEL=boot /mnt/boot",
        "udevadm settle")
    '';
    extraConfig = ''
      boot.initrd.clevis.devices."rpool/root".secretFile = "/etc/nixos/clevis-secret.jwe";
      boot.zfs.requestEncryptionCredentials = true;


      # Using by-uuid overrides the default of by-id, and is unique
      # to the qemu disks, as they don't produce by-id paths for
      # some reason.
      boot.zfs.devNodes = "/dev/disk/by-uuid/";
      networking.hostId = "00000000";
    '';
    preBootCommands = ''
      tpm = Tpm()
      tpm.check()
    '' + optionalString fallback ''
      machine.start()
      ${if systemdStage1 then ''
      machine.wait_for_text("Enter key for rpool/root")
      '' else ''
      machine.wait_for_text("Key load error")
      ''}
      machine.send_chars("password\n")
    '';
  };

in {

  # !!! `parted mkpart' seems to silently create overlapping partitions.


  # The (almost) simplest partitioning scheme: a swap partition and
  # one big filesystem partition.
  simple = makeInstallerTest "simple" simple-test-config;

  switchToFlake = makeInstallerTest "switch-to-flake" simple-test-config-flake;

  # Test cloned configurations with the simple grub configuration
  simpleSpecialised = makeInstallerTest "simpleSpecialised" (simple-test-config // specialisation-test-extraconfig);

  # Simple GPT/UEFI configuration using systemd-boot with 3 partitions: ESP, swap & root filesystem
  simpleUefiSystemdBoot = makeInstallerTest "simpleUefiSystemdBoot" {
    createPartitions = ''
      machine.succeed(
          "flock /dev/vda parted --script /dev/vda -- mklabel gpt"
          + " mkpart ESP fat32 1M 100MiB"  # /boot
          + " set 1 boot on"
          + " mkpart primary linux-swap 100MiB 1024MiB"
          + " mkpart primary ext2 1024MiB -1MiB",  # /
          "udevadm settle",
          "mkswap /dev/vda2 -L swap",
          "swapon -L swap",
          "mkfs.ext3 -L nixos /dev/vda3",
          "mount LABEL=nixos /mnt",
          "mkfs.vfat -n BOOT /dev/vda1",
          "mkdir -p /mnt/boot",
          "mount LABEL=BOOT /mnt/boot",
      )
    '';
    bootLoader = "systemd-boot";
  };

  simpleUefiGrub = makeInstallerTest "simpleUefiGrub" simple-uefi-grub-config;

  # Test cloned configurations with the uefi grub configuration
  simpleUefiGrubSpecialisation = makeInstallerTest "simpleUefiGrubSpecialisation" (simple-uefi-grub-config // specialisation-test-extraconfig);

  # Same as the previous, but now with a separate /boot partition.
  separateBoot = makeInstallerTest "separateBoot" {
    createPartitions = ''
      machine.succeed(
          "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
          + " mkpart primary ext2 1M 100MB"  # /boot
          + " mkpart primary linux-swap 100MB 1024M"
          + " mkpart primary ext2 1024M -1s",  # /
          "udevadm settle",
          "mkswap /dev/vda2 -L swap",
          "swapon -L swap",
          "mkfs.ext3 -L nixos /dev/vda3",
          "mount LABEL=nixos /mnt",
          "mkfs.ext3 -L boot /dev/vda1",
          "mkdir -p /mnt/boot",
          "mount LABEL=boot /mnt/boot",
      )
    '';
  };

  # Same as the previous, but with fat32 /boot.
  separateBootFat = makeInstallerTest "separateBootFat" {
    createPartitions = ''
      machine.succeed(
          "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
          + " mkpart primary ext2 1M 100MB"  # /boot
          + " mkpart primary linux-swap 100MB 1024M"
          + " mkpart primary ext2 1024M -1s",  # /
          "udevadm settle",
          "mkswap /dev/vda2 -L swap",
          "swapon -L swap",
          "mkfs.ext3 -L nixos /dev/vda3",
          "mount LABEL=nixos /mnt",
          "mkfs.vfat -n BOOT /dev/vda1",
          "mkdir -p /mnt/boot",
          "mount LABEL=BOOT /mnt/boot",
      )
    '';
  };

  # Same as the previous, but with ZFS /boot.
  separateBootZfs = makeInstallerTest "separateBootZfs" {
    extraInstallerConfig = {
      boot.supportedFilesystems = [ "zfs" ];
    };

    extraConfig = ''
      # Using by-uuid overrides the default of by-id, and is unique
      # to the qemu disks, as they don't produce by-id paths for
      # some reason.
      boot.zfs.devNodes = "/dev/disk/by-uuid/";
      networking.hostId = "00000000";
    '';

    createPartitions = ''
      machine.succeed(
          "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
          + " mkpart primary ext2 1M 256MB"   # /boot
          + " mkpart primary linux-swap 256MB 1280M"
          + " mkpart primary ext2 1280M -1s", # /
          "udevadm settle",

          "mkswap /dev/vda2 -L swap",
          "swapon -L swap",

          "mkfs.ext4 -L nixos /dev/vda3",
          "mount LABEL=nixos /mnt",

          # Use as many ZFS features as possible to verify that GRUB can handle them
          "zpool create"
            " -o compatibility=grub2"
            " -O utf8only=on"
            " -O normalization=formD"
            " -O compression=lz4"      # Activate the lz4_compress feature
            " -O xattr=sa"
            " -O acltype=posixacl"
            " bpool /dev/vda1",
          "zfs create"
            " -o recordsize=1M"        # Prepare activating the large_blocks feature
            " -o mountpoint=legacy"
            " -o relatime=on"
            " -o quota=1G"
            " -o filesystem_limit=100" # Activate the filesystem_limits features
            " bpool/boot",

          # Snapshotting the top-level dataset would trigger a bug in GRUB2: https://github.com/openzfs/zfs/issues/13873
          "zfs snapshot bpool/boot@snap-1",                     # Prepare activating the livelist and bookmarks features
          "zfs clone bpool/boot@snap-1 bpool/test",             # Activate the livelist feature
          "zfs bookmark bpool/boot@snap-1 bpool/boot#bookmark", # Activate the bookmarks feature
          "zpool checkpoint bpool",                             # Activate the zpool_checkpoint feature
          "mkdir -p /mnt/boot",
          "mount -t zfs bpool/boot /mnt/boot",
          "touch /mnt/boot/empty",                              # Activate zilsaxattr feature
          "dd if=/dev/urandom of=/mnt/boot/test bs=1M count=1", # Activate the large_blocks feature

          # Print out all enabled and active ZFS features (and some other stuff)
          "sync /mnt/boot",
          "zpool get all bpool >&2",

          # Abort early if GRUB2 doesn't like the disks
          "grub-probe --target=device /mnt/boot >&2",
      )
    '';

    # umount & export bpool before shutdown
    # this is a fix for "cannot import 'bpool': pool was previously in use from another system."
    postInstallCommands = ''
      machine.succeed("umount /mnt/boot")
      machine.succeed("zpool export bpool")
    '';
  };

  # zfs on / with swap
  zfsroot = makeInstallerTest "zfs-root" {
    extraInstallerConfig = {
      boot.supportedFilesystems = [ "zfs" ];
    };

    extraConfig = ''
      boot.supportedFilesystems = [ "zfs" ];

      # Using by-uuid overrides the default of by-id, and is unique
      # to the qemu disks, as they don't produce by-id paths for
      # some reason.
      boot.zfs.devNodes = "/dev/disk/by-uuid/";
      networking.hostId = "00000000";
    '';

    createPartitions = ''
      machine.succeed(
          "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
          + " mkpart primary 1M 100MB"  # /boot
          + " mkpart primary linux-swap 100M 1024M"
          + " mkpart primary 1024M -1s", # rpool
          "udevadm settle",
          "mkswap /dev/vda2 -L swap",
          "swapon -L swap",
          "zpool create rpool /dev/vda3",
          "zfs create -o mountpoint=legacy rpool/root",
          "mount -t zfs rpool/root /mnt",
          "zfs create -o mountpoint=legacy rpool/root/usr",
          "mkdir /mnt/usr",
          "mount -t zfs rpool/root/usr /mnt/usr",
          "mkfs.vfat -n BOOT /dev/vda1",
          "mkdir /mnt/boot",
          "mount LABEL=BOOT /mnt/boot",
          "udevadm settle",
      )
    '';
  };

  # Create two physical LVM partitions combined into one volume group
  # that contains the logical swap and root partitions.
  lvm = makeInstallerTest "lvm" {
    createPartitions = ''
      machine.succeed(
          "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
          + " mkpart primary 1M 2048M"  # PV1
          + " set 1 lvm on"
          + " mkpart primary 2048M -1s"  # PV2
          + " set 2 lvm on",
          "udevadm settle",
          "pvcreate /dev/vda1 /dev/vda2",
          "vgcreate MyVolGroup /dev/vda1 /dev/vda2",
          "lvcreate --size 1G --name swap MyVolGroup",
          "lvcreate --size 6G --name nixos MyVolGroup",
          "mkswap -f /dev/MyVolGroup/swap -L swap",
          "swapon -L swap",
          "mkfs.xfs -L nixos /dev/MyVolGroup/nixos",
          "mount LABEL=nixos /mnt",
      )
    '';
  };

  # Boot off an encrypted root partition with the default LUKS header format
  luksroot = makeLuksRootTest "luksroot-format1" "";

  # Boot off an encrypted root partition with LUKS1 format
  luksroot-format1 = makeLuksRootTest "luksroot-format1" "--type=LUKS1";

  # Boot off an encrypted root partition with LUKS2 format
  luksroot-format2 = makeLuksRootTest "luksroot-format2" "--type=LUKS2";

  # Test whether opening encrypted filesystem with keyfile
  # Checks for regression of missing cryptsetup, when no luks device without
  # keyfile is configured
  encryptedFSWithKeyfile = makeInstallerTest "encryptedFSWithKeyfile" {
    createPartitions = ''
      machine.succeed(
          "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
          + " mkpart primary ext2 1M 100MB"  # /boot
          + " mkpart primary linux-swap 100M 1024M"
          + " mkpart primary 1024M 1280M"  # LUKS with keyfile
          + " mkpart primary 1280M -1s",
          "udevadm settle",
          "mkswap /dev/vda2 -L swap",
          "swapon -L swap",
          "mkfs.ext3 -L nixos /dev/vda4",
          "mount LABEL=nixos /mnt",
          "mkfs.ext3 -L boot /dev/vda1",
          "mkdir -p /mnt/boot",
          "mount LABEL=boot /mnt/boot",
          "modprobe dm_mod dm_crypt",
          "echo -n supersecret > /mnt/keyfile",
          "cryptsetup luksFormat -q /dev/vda3 --key-file /mnt/keyfile",
          "cryptsetup luksOpen --key-file /mnt/keyfile /dev/vda3 crypt",
          "mkfs.ext3 -L test /dev/mapper/crypt",
          "cryptsetup luksClose crypt",
          "mkdir -p /mnt/test",
      )
    '';
    extraConfig = ''
      fileSystems."/test" = {
        device = "/dev/disk/by-label/test";
        fsType = "ext3";
        encrypted.enable = true;
        encrypted.blkDev = "/dev/vda3";
        encrypted.label = "crypt";
        encrypted.keyFile = "/${if systemdStage1 then "sysroot" else "mnt-root"}/keyfile";
      };
    '';
  };

  # Full disk encryption (root, kernel and initrd encrypted) using GRUB, GPT/UEFI,
  # LVM-on-LUKS and a keyfile in initrd.secrets to enter the passphrase once
  fullDiskEncryption = makeInstallerTest "fullDiskEncryption" {
    createPartitions = ''
      machine.succeed(
          "flock /dev/vda parted --script /dev/vda -- mklabel gpt"
          + " mkpart ESP fat32 1M 100MiB"  # /boot/efi
          + " set 1 boot on"
          + " mkpart primary ext2 1024MiB -1MiB",  # LUKS
          "udevadm settle",
          "modprobe dm_mod dm_crypt",
          "dd if=/dev/random of=luks.key bs=256 count=1",
          "echo -n supersecret | cryptsetup luksFormat -q --pbkdf-force-iterations 1000 --type luks1 /dev/vda2 -",
          "echo -n supersecret | cryptsetup luksAddKey -q --pbkdf-force-iterations 1000 --key-file - /dev/vda2 luks.key",
          "echo -n supersecret | cryptsetup luksOpen --key-file - /dev/vda2 crypt",
          "pvcreate /dev/mapper/crypt",
          "vgcreate crypt /dev/mapper/crypt",
          "lvcreate -L 100M -n swap crypt",
          "lvcreate -l '100%FREE' -n nixos crypt",
          "mkfs.vfat -n efi /dev/vda1",
          "mkfs.ext4 -L nixos /dev/crypt/nixos",
          "mkswap -L swap /dev/crypt/swap",
          "mount LABEL=nixos /mnt",
          "mkdir -p /mnt/{etc/nixos,boot/efi}",
          "mount LABEL=efi /mnt/boot/efi",
          "swapon -L swap",
          "mv luks.key /mnt/etc/nixos/"
      )
    '';
    bootLoader = "grub";
    grubUseEfi = true;
    extraConfig = ''
      boot.loader.grub.enableCryptodisk = true;
      boot.loader.efi.efiSysMountPoint = "/boot/efi";

      boot.initrd.secrets."/luks.key" = ./luks.key;
      boot.initrd.luks.devices.crypt =
        { device  = "/dev/vda2";
          keyFile = "/luks.key";
        };
    '';
    enableOCR = true;
    preBootCommands = ''
      machine.start()
      machine.wait_for_text("Enter passphrase for")
      machine.send_chars("supersecret\n")
    '';
  };

  swraid = makeInstallerTest "swraid" {
    createPartitions = ''
      machine.succeed(
          "flock /dev/vda parted --script /dev/vda --"
          + " mklabel msdos"
          + " mkpart primary ext2 1M 100MB"  # /boot
          + " mkpart extended 100M -1s"
          + " mkpart logical 102M 3102M"  # md0 (root), first device
          + " mkpart logical 3103M 6103M"  # md0 (root), second device
          + " mkpart logical 6104M 6360M"  # md1 (swap), first device
          + " mkpart logical 6361M 6617M",  # md1 (swap), second device
          "udevadm settle",
          "ls -l /dev/vda* >&2",
          "cat /proc/partitions >&2",
          "udevadm control --stop-exec-queue",
          "mdadm --create --force /dev/md0 --metadata 1.2 --level=raid1 "
          + "--raid-devices=2 /dev/vda5 /dev/vda6",
          "mdadm --create --force /dev/md1 --metadata 1.2 --level=raid1 "
          + "--raid-devices=2 /dev/vda7 /dev/vda8",
          "udevadm control --start-exec-queue",
          "udevadm settle",
          "mkswap -f /dev/md1 -L swap",
          "swapon -L swap",
          "mkfs.ext3 -L nixos /dev/md0",
          "mount LABEL=nixos /mnt",
          "mkfs.ext3 -L boot /dev/vda1",
          "mkdir /mnt/boot",
          "mount LABEL=boot /mnt/boot",
          "udevadm settle",
      )
    '';
    preBootCommands = ''
      machine.start()
      machine.fail("dmesg | grep 'immediate safe mode'")
    '';
  };

  bcache = makeInstallerTest "bcache" {
    createPartitions = ''
      machine.succeed(
          "flock /dev/vda parted --script /dev/vda --"
          + " mklabel msdos"
          + " mkpart primary ext2 1M 100MB"  # /boot
          + " mkpart primary 100MB 512MB  "  # swap
          + " mkpart primary 512MB 1024MB"  # Cache (typically SSD)
          + " mkpart primary 1024MB -1s ",  # Backing device (typically HDD)
          "modprobe bcache",
          "udevadm settle",
          "make-bcache -B /dev/vda4 -C /dev/vda3",
          "udevadm settle",
          "mkfs.ext3 -L nixos /dev/bcache0",
          "mount LABEL=nixos /mnt",
          "mkfs.ext3 -L boot /dev/vda1",
          "mkdir /mnt/boot",
          "mount LABEL=boot /mnt/boot",
          "mkswap -f /dev/vda2 -L swap",
          "swapon -L swap",
      )
    '';
  };

  bcachefsSimple = makeInstallerTest "bcachefs-simple" {
    extraInstallerConfig = {
      boot.supportedFilesystems = [ "bcachefs" ];
      imports = [ no-zfs-module ];
    };

    createPartitions = ''
      machine.succeed(
        "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
        + " mkpart primary ext2 1M 100MB"          # /boot
        + " mkpart primary linux-swap 100M 1024M"  # swap
        + " mkpart primary 1024M -1s",             # /
        "udevadm settle",
        "mkswap /dev/vda2 -L swap",
        "swapon -L swap",
        "mkfs.bcachefs -L root /dev/vda3",
        "mount -t bcachefs /dev/vda3 /mnt",
        "mkfs.ext3 -L boot /dev/vda1",
        "mkdir -p /mnt/boot",
        "mount /dev/vda1 /mnt/boot",
      )
    '';
  };

  bcachefsEncrypted = makeInstallerTest "bcachefs-encrypted" {
    extraInstallerConfig = {
      boot.supportedFilesystems = [ "bcachefs" ];

      # disable zfs so we can support latest kernel if needed
      imports = [ no-zfs-module ];

      environment.systemPackages = with pkgs; [ keyutils ];
    };

    extraConfig = ''
      boot.kernelParams = lib.mkAfter [ "console=tty0" ];
    '';

    enableOCR = true;
    preBootCommands = ''
      machine.start()
      # Enter it wrong once
      machine.wait_for_text("enter passphrase for ")
      machine.send_chars("wrong\n")
      # Then enter it right.
      machine.wait_for_text("enter passphrase for ")
      machine.send_chars("password\n")
    '';

    createPartitions = ''
      machine.succeed(
        "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
        + " mkpart primary ext2 1M 100MB"          # /boot
        + " mkpart primary linux-swap 100M 1024M"  # swap
        + " mkpart primary 1024M -1s",             # /
        "udevadm settle",
        "mkswap /dev/vda2 -L swap",
        "swapon -L swap",
        "echo password | mkfs.bcachefs -L root --encrypted /dev/vda3",
        "echo password | bcachefs unlock -k session /dev/vda3",
        "echo password | mount -t bcachefs /dev/vda3 /mnt",
        "mkfs.ext3 -L boot /dev/vda1",
        "mkdir -p /mnt/boot",
        "mount /dev/vda1 /mnt/boot",
      )
    '';
  };

  bcachefsMulti = makeInstallerTest "bcachefs-multi" {
    extraInstallerConfig = {
      boot.supportedFilesystems = [ "bcachefs" ];

      # disable zfs so we can support latest kernel if needed
      imports = [ no-zfs-module ];
    };

    createPartitions = ''
      machine.succeed(
        "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
        + " mkpart primary ext2 1M 100MB"          # /boot
        + " mkpart primary linux-swap 100M 1024M"  # swap
        + " mkpart primary 1024M 4096M"            # /
        + " mkpart primary 4096M -1s",             # /
        "udevadm settle",
        "mkswap /dev/vda2 -L swap",
        "swapon -L swap",
        "mkfs.bcachefs -L root --metadata_replicas 2 --foreground_target ssd --promote_target ssd --background_target hdd --label ssd /dev/vda3 --label hdd /dev/vda4",
        "mount -t bcachefs /dev/vda3:/dev/vda4 /mnt",
        "mkfs.ext3 -L boot /dev/vda1",
        "mkdir -p /mnt/boot",
        "mount /dev/vda1 /mnt/boot",
      )
    '';
  };

  # Test using labels to identify volumes in grub
  simpleLabels = makeInstallerTest "simpleLabels" {
    createPartitions = ''
      machine.succeed(
          "sgdisk -Z /dev/vda",
          "sgdisk -n 1:0:+1M -n 2:0:+1G -N 3 -t 1:ef02 -t 2:8200 -t 3:8300 -c 3:root /dev/vda",
          "mkswap /dev/vda2 -L swap",
          "swapon -L swap",
          "mkfs.ext4 -L root /dev/vda3",
          "mount LABEL=root /mnt",
      )
    '';
    grubIdentifier = "label";
  };

  # Test using the provided disk name within grub
  # TODO: Fix udev so the symlinks are unneeded in /dev/disks
  simpleProvided = makeInstallerTest "simpleProvided" {
    createPartitions = ''
      uuid = "$(blkid -s UUID -o value /dev/vda2)"
      machine.succeed(
          "sgdisk -Z /dev/vda",
          "sgdisk -n 1:0:+1M -n 2:0:+100M -n 3:0:+1G -N 4 -t 1:ef02 -t 2:8300 "
          + "-t 3:8200 -t 4:8300 -c 2:boot -c 4:root /dev/vda",
          "mkswap /dev/vda3 -L swap",
          "swapon -L swap",
          "mkfs.ext4 -L boot /dev/vda2",
          "mkfs.ext4 -L root /dev/vda4",
      )
      machine.execute(f"ln -s ../../vda2 /dev/disk/by-uuid/{uuid}")
      machine.execute("ln -s ../../vda4 /dev/disk/by-label/root")
      machine.succeed(
          "mount /dev/disk/by-label/root /mnt",
          "mkdir /mnt/boot",
          f"mount /dev/disk/by-uuid/{uuid} /mnt/boot",
      )
    '';
    grubIdentifier = "provided";
  };

  # Simple btrfs grub testing
  btrfsSimple = makeInstallerTest "btrfsSimple" {
    createPartitions = ''
      machine.succeed(
          "sgdisk -Z /dev/vda",
          "sgdisk -n 1:0:+1M -n 2:0:+1G -N 3 -t 1:ef02 -t 2:8200 -t 3:8300 -c 3:root /dev/vda",
          "mkswap /dev/vda2 -L swap",
          "swapon -L swap",
          "mkfs.btrfs -L root /dev/vda3",
          "mount LABEL=root /mnt",
      )
    '';
  };

  # Test to see if we can detect /boot and /nix on subvolumes
  btrfsSubvols = makeInstallerTest "btrfsSubvols" {
    createPartitions = ''
      machine.succeed(
          "sgdisk -Z /dev/vda",
          "sgdisk -n 1:0:+1M -n 2:0:+1G -N 3 -t 1:ef02 -t 2:8200 -t 3:8300 -c 3:root /dev/vda",
          "mkswap /dev/vda2 -L swap",
          "swapon -L swap",
          "mkfs.btrfs -L root /dev/vda3",
          "btrfs device scan",
          "mount LABEL=root /mnt",
          "btrfs subvol create /mnt/boot",
          "btrfs subvol create /mnt/nixos",
          "btrfs subvol create /mnt/nixos/default",
          "umount /mnt",
          "mount -o defaults,subvol=nixos/default LABEL=root /mnt",
          "mkdir /mnt/boot",
          "mount -o defaults,subvol=boot LABEL=root /mnt/boot",
      )
    '';
  };

  # Test to see if we can detect default and aux subvolumes correctly
  btrfsSubvolDefault = makeInstallerTest "btrfsSubvolDefault" {
    createPartitions = ''
      machine.succeed(
          "sgdisk -Z /dev/vda",
          "sgdisk -n 1:0:+1M -n 2:0:+1G -N 3 -t 1:ef02 -t 2:8200 -t 3:8300 -c 3:root /dev/vda",
          "mkswap /dev/vda2 -L swap",
          "swapon -L swap",
          "mkfs.btrfs -L root /dev/vda3",
          "btrfs device scan",
          "mount LABEL=root /mnt",
          "btrfs subvol create /mnt/badpath",
          "btrfs subvol create /mnt/badpath/boot",
          "btrfs subvol create /mnt/nixos",
          "btrfs subvol set-default "
          + "$(btrfs subvol list /mnt | grep 'nixos' | awk '{print $2}') /mnt",
          "umount /mnt",
          "mount -o defaults LABEL=root /mnt",
          "mkdir -p /mnt/badpath/boot",  # Help ensure the detection mechanism
          # is actually looking up subvolumes
          "mkdir /mnt/boot",
          "mount -o defaults,subvol=badpath/boot LABEL=root /mnt/boot",
      )
    '';
  };

  # Test to see if we can deal with subvols that need to be escaped in fstab
  btrfsSubvolEscape = makeInstallerTest "btrfsSubvolEscape" {
    createPartitions = ''
      machine.succeed(
          "sgdisk -Z /dev/vda",
          "sgdisk -n 1:0:+1M -n 2:0:+1G -N 3 -t 1:ef02 -t 2:8200 -t 3:8300 -c 3:root /dev/vda",
          "mkswap /dev/vda2 -L swap",
          "swapon -L swap",
          "mkfs.btrfs -L root /dev/vda3",
          "btrfs device scan",
          "mount LABEL=root /mnt",
          "btrfs subvol create '/mnt/nixos in space'",
          "btrfs subvol create /mnt/boot",
          "umount /mnt",
          "mount -o 'defaults,subvol=nixos in space' LABEL=root /mnt",
          "mkdir /mnt/boot",
          "mount -o defaults,subvol=boot LABEL=root /mnt/boot",
      )
    '';
  };
} // {
  clevisBcachefs = mkClevisBcachefsTest { };
  clevisBcachefsFallback = mkClevisBcachefsTest { fallback = true; };
  clevisLuks = mkClevisLuksTest { };
  clevisLuksFallback = mkClevisLuksTest { fallback = true; };
  clevisZfs = mkClevisZfsTest { };
  clevisZfsFallback = mkClevisZfsTest { fallback = true; };
} // optionalAttrs systemdStage1 {
  stratisRoot = makeInstallerTest "stratisRoot" {
    createPartitions = ''
      machine.succeed(
        "sgdisk --zap-all /dev/vda",
        "sgdisk --new=1:0:+100M --typecode=0:ef00 /dev/vda", # /boot
        "sgdisk --new=2:0:+1G --typecode=0:8200 /dev/vda", # swap
        "sgdisk --new=3:0:+5G --typecode=0:8300 /dev/vda", # /
        "udevadm settle",

        "mkfs.vfat /dev/vda1",
        "mkswap /dev/vda2 -L swap",
        "swapon -L swap",
        "stratis pool create my-pool /dev/vda3",
        "stratis filesystem create my-pool nixos",
        "udevadm settle",

        "mount /dev/stratis/my-pool/nixos /mnt",
        "mkdir -p /mnt/boot",
        "mount /dev/vda1 /mnt/boot"
      )
    '';
    bootLoader = "systemd-boot";
    extraInstallerConfig = { modulesPath, ...}: {
      config = {
        services.stratis.enable = true;
        environment.systemPackages = [
          pkgs.stratis-cli
          pkgs.thin-provisioning-tools
          pkgs.lvm2.bin
          pkgs.stratisd.initrd
        ];
      };
    };
  };
}
