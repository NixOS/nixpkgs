{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
  systemdStage1 ? false,
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let

  # The configuration to install.
  makeConfig =
    {
      bootLoader,
      grubDevice,
      grubIdentifier,
      grubUseEfi,
      extraConfig,
      forceGrubReinstallCount ? 0,
      withTestInstrumentation ? true,
      clevisTest,
    }:
    pkgs.writeText "configuration.nix" ''
      { config, lib, pkgs, modulesPath, ... }:

      { imports =
          [ ./hardware-configuration.nix
            ${
              if !withTestInstrumentation then
                "" # Still included, but via installer/flake.nix
              else
                "<nixpkgs/nixos/modules/testing/test-instrumentation.nix>"
            }
          ];

        networking.hostName = "thatworked";

        documentation.enable = false;

        # To ensure that we can rebuild the grub configuration on the nixos-rebuild
        system.extraDependencies = with pkgs; [ stdenvNoCC ];

        ${optionalString systemdStage1 "boot.initrd.systemd.enable = true;"}

        ${optionalString (bootLoader == "grub") ''
          boot.loader.grub.extraConfig = "serial; terminal_output serial";
          ${
            if grubUseEfi then
              ''
                boot.loader.grub.device = "nodev";
                boot.loader.grub.efiSupport = true;
                boot.loader.grub.efiInstallAsRemovable = true; # XXX: needed for OVMF?
              ''
            else
              ''
                boot.loader.grub.device = "${grubDevice}";
                boot.loader.grub.fsIdentifier = "${grubIdentifier}";
              ''
          }

          boot.loader.grub.configurationLimit = 100 + ${toString forceGrubReinstallCount};
        ''}

        ${optionalString (bootLoader == "systemd-boot") ''
          boot.loader.systemd-boot.enable = true;
        ''}

        boot.initrd.secrets."/etc/secret" = "/etc/nixos/secret";

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

        ${replaceStrings [ "\n" ] [ "\n  " ] extraConfig}
      }
    '';

  # The test script boots a NixOS VM, installs NixOS on an empty hard
  # disk, and then reboot from the hard disk.  It's parameterized with
  # a test script fragment `createPartitions', which must create
  # partitions and filesystems.
  testScriptFun =
    {
      bootLoader,
      createPartitions,
      grubDevice,
      grubUseEfi,
      grubIdentifier,
      postInstallCommands,
      postBootCommands,
      extraConfig,
      testSpecialisationConfig,
      testFlakeSwitch,
      testByAttrSwitch,
      clevisTest,
      clevisFallbackTest,
      disableFileSystems,
    }:
    let
      startTarget = ''
        ${optionalString clevisTest "tpm.start()"}
        target.start()
        ${postBootCommands}
        target.wait_for_unit("multi-user.target")
      '';
    in
    ''
      ${optionalString clevisTest ''
        import os
        import subprocess

        tpm_folder = os.environ['NIX_BUILD_TOP']

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
      ''}

      installer.start()
      ${optionalString clevisTest ''
        tang.start()
        tang.wait_for_unit("sockets.target")
        tang.systemctl("start network-online.target")
        tang.wait_for_unit("network-online.target")
        installer.systemctl("start network-online.target")
        installer.wait_for_unit("network-online.target")
      ''}
      installer.wait_for_unit("multi-user.target")

      with subtest("Assert readiness of login prompt"):
          installer.succeed("echo hello")

      with subtest("Wait for hard disks to appear in /dev"):
          installer.succeed("udevadm settle")

      ${createPartitions}

      with subtest("Create the NixOS configuration"):
          installer.succeed("nixos-generate-config ${optionalString disableFileSystems "--no-filesystems"} --root /mnt")
          installer.succeed("cat /mnt/etc/nixos/hardware-configuration.nix >&2")
          installer.copy_from_host(
              "${
                makeConfig {
                  inherit
                    bootLoader
                    grubDevice
                    grubIdentifier
                    grubUseEfi
                    extraConfig
                    clevisTest
                    ;
                }
              }",
              "/mnt/etc/nixos/configuration.nix",
          )
          installer.copy_from_host("${pkgs.writeText "secret" "secret"}", "/mnt/etc/nixos/secret")

      ${optionalString clevisTest ''
        with subtest("Create the Clevis secret with Tang"):
             installer.systemctl("start network-online.target")
             installer.wait_for_unit("network-online.target")
             installer.succeed('echo -n password | clevis encrypt sss \'{"t": 2, "pins": {"tpm2": {}, "tang": {"url": "http://192.168.1.2"}}}\' -y > /mnt/etc/nixos/clevis-secret.jwe')''}

      ${optionalString clevisFallbackTest ''
        with subtest("Shutdown Tang to check fallback to interactive prompt"):
            tang.shutdown()
      ''}

      with subtest("Perform the installation"):
          installer.succeed("nixos-install < /dev/null >&2")

      with subtest("Do it again to make sure it's idempotent"):
          installer.succeed("nixos-install < /dev/null >&2")

      with subtest("Check that we can build things in nixos-enter"):
          installer.succeed(
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
          installer.succeed("umount -R /mnt")
          installer.succeed("sync")
          installer.shutdown()

      # We're actually the same machine, just booting differently this time.
      target.state_dir = installer.state_dir

      # Now see if we can boot the installation.
      ${startTarget}

      with subtest("Assert that /boot get mounted"):
          target.wait_for_unit("local-fs.target")
          ${
            if bootLoader == "grub" then
              ''target.succeed("test -e /boot/grub")''
            else
              ''target.succeed("test -e /boot/loader/loader.conf")''
          }

      with subtest("Check whether /root has correct permissions"):
          assert "700" in target.succeed("stat -c '%a' /root")

      with subtest("Assert swap device got activated"):
          # uncomment once https://bugs.freedesktop.org/show_bug.cgi?id=86930 is resolved
          target.wait_for_unit("swap.target")
          target.succeed("cat /proc/swaps | grep -q /dev")

      with subtest("Check that the store is in good shape"):
          target.succeed("nix-store --verify --check-contents >&2")

      with subtest("Check whether the channel works"):
          target.succeed("nix-env -iA nixos.procps >&2")
          assert ".nix-profile" in target.succeed("type -tP ps | tee /dev/stderr")

      with subtest(
          "Check that the daemon works, and that non-root users can run builds "
          "(this will build a new profile generation through the daemon)"
      ):
          target.succeed("su alice -l -c 'nix-env -iA nixos.procps' >&2")

      with subtest("Configure system with writable Nix store on next boot"):
          # we're not using copy_from_host here because the installer image
          # doesn't know about the host-guest sharing mechanism.
          target.copy_from_host_via_shell(
              "${
                makeConfig {
                  inherit
                    bootLoader
                    grubDevice
                    grubIdentifier
                    grubUseEfi
                    extraConfig
                    clevisTest
                    ;
                  forceGrubReinstallCount = 1;
                }
              }",
              "/etc/nixos/configuration.nix",
          )

      with subtest("Check whether nixos-rebuild works"):
          target.succeed("nixos-rebuild switch >&2")

      with subtest("Test nixos-option"):
          kernel_modules = target.succeed("nixos-option boot.initrd.kernelModules")
          assert "virtio_console" in kernel_modules
          assert "list of modules" in kernel_modules
          assert "qemu-guest.nix" in kernel_modules

      target.shutdown()

      # Check whether a writable store build works
      ${startTarget}

      # we're not using copy_from_host here because the installer image
      # doesn't know about the host-guest sharing mechanism.
      target.copy_from_host_via_shell(
          "${
            makeConfig {
              inherit
                bootLoader
                grubDevice
                grubIdentifier
                grubUseEfi
                extraConfig
                clevisTest
                ;
              forceGrubReinstallCount = 2;
            }
          }",
          "/etc/nixos/configuration.nix",
      )
      target.succeed("nixos-rebuild boot >&2")
      target.shutdown()

      # And just to be sure, check that the target still boots after "nixos-rebuild switch".
      ${startTarget}
      target.wait_for_unit("network.target")

      # Sanity check, is it the configuration.nix we generated?
      hostname = target.succeed("hostname").strip()
      assert hostname == "thatworked"

      target.shutdown()

      # Tests for validating clone configuration entries in grub menu
    ''
    + optionalString testSpecialisationConfig ''
      # Reboot target
      ${startTarget}

      with subtest("Booted configuration name should be 'Home'"):
          # This is not the name that shows in the grub menu.
          # The default configuration is always shown as "Default"
          target.succeed("cat /run/booted-system/configuration-name >&2")
          assert "Home" in target.succeed("cat /run/booted-system/configuration-name")

      with subtest("We should **not** find a file named /etc/gitconfig"):
          target.fail("test -e /etc/gitconfig")

      with subtest("Set grub to boot the second configuration"):
          target.succeed("grub-reboot 1")

      target.shutdown()

      # Reboot target
      ${startTarget}

      with subtest("Booted configuration name should be Work"):
          target.succeed("cat /run/booted-system/configuration-name >&2")
          assert "Work" in target.succeed("cat /run/booted-system/configuration-name")

      with subtest("We should find a file named /etc/gitconfig"):
          target.succeed("test -e /etc/gitconfig")

      target.shutdown()
    ''
    + optionalString testByAttrSwitch ''
      with subtest("Configure system with attribute set"):
        target.succeed("""
          mkdir /root/my-config
          mv /etc/nixos/hardware-configuration.nix /root/my-config/
          rm /etc/nixos/configuration.nix
        """)
        target.copy_from_host_via_shell(
          "${
            makeConfig {
              inherit
                bootLoader
                grubDevice
                grubIdentifier
                grubUseEfi
                extraConfig
                clevisTest
                ;
              forceGrubReinstallCount = 1;
              withTestInstrumentation = false;
            }
          }",
          "/root/my-config/configuration.nix",
        )
        target.copy_from_host_via_shell(
          "${./installer/byAttrWithChannel.nix}",
          "/root/my-config/default.nix",
        )
      with subtest("Switch to attribute set based config with channels"):
        target.succeed("nixos-rebuild switch --file /root/my-config/default.nix")

      target.shutdown()

      ${startTarget}

      target.succeed("""
        rm /root/my-config/default.nix
      """)
      target.copy_from_host_via_shell(
        "${./installer/byAttrNoChannel.nix}",
        "/root/my-config/default.nix",
      )

      target.succeed("""
        pkgs=$(readlink -f /nix/var/nix/profiles/per-user/root/channels)/nixos
        if ! [[ -e $pkgs/pkgs/top-level/default.nix ]]; then
          echo 1>&2 "$pkgs does not seem to be a nixpkgs source. Please fix the test so that pkgs points to a nixpkgs source.";
          exit 1;
        fi
        sed -e s^@nixpkgs@^$pkgs^ -i /root/my-config/default.nix

      """)

      with subtest("Switch to attribute set based config without channels"):
        target.succeed("nixos-rebuild switch --file /root/my-config/default.nix")

      target.shutdown()

      ${startTarget}

      with subtest("nix-channel command is not available anymore"):
        target.succeed("! which nix-channel")

      with subtest("builtins.nixPath is now empty"):
        target.succeed("""
          [[ "[ ]" == "$(nix-instantiate builtins.nixPath --eval --expr)" ]]
        """)

      with subtest("<nixpkgs> does not resolve"):
        target.succeed("""
          ! nix-instantiate '<nixpkgs>' --eval --expr
        """)

      with subtest("Evaluate attribute set based config in fresh env without nix-channel"):
        target.succeed("nixos-rebuild switch --file /root/my-config/default.nix")

      with subtest("Evaluate attribute set based config in fresh env without channel profiles"):
        target.succeed("""
          (
            exec 1>&2
            mkdir -p /root/restore
            mv -v /root/.nix-channels /root/restore/
            mv -v ~/.nix-defexpr /root/restore/
            mkdir -p /root/restore/channels
            mv -v /nix/var/nix/profiles/per-user/root/channels* /root/restore/channels/
          )
        """)
        target.succeed("nixos-rebuild switch --file /root/my-config/default.nix")
    ''
    + optionalString (testByAttrSwitch && testFlakeSwitch) ''
      with subtest("Restore channel profiles"):
        target.succeed("""
          (
            exec 1>&2
            mv -v /root/restore/.nix-channels /root/
            mv -v /root/restore/.nix-defexpr ~/.nix-defexpr
            mv -v /root/restore/channels/* /nix/var/nix/profiles/per-user/root/
            rm -vrf /root/restore
          )
        """)

      with subtest("Restore /etc/nixos"):
        target.succeed("""
          mv -v /root/my-config/hardware-configuration.nix /etc/nixos/
        """)
        target.copy_from_host_via_shell(
          "${
            makeConfig {
              inherit
                bootLoader
                grubDevice
                grubIdentifier
                grubUseEfi
                extraConfig
                clevisTest
                ;
              forceGrubReinstallCount = 1;
            }
          }",
          "/etc/nixos/configuration.nix",
        )

      with subtest("Restore /root/my-config"):
        target.succeed("""
          rm -vrf /root/my-config
        """)

    ''
    + optionalString (testByAttrSwitch && !testFlakeSwitch) ''
      target.shutdown()
    ''
    + optionalString testFlakeSwitch ''
      ${startTarget}

      with subtest("Configure system with flake"):
        # TODO: evaluate as user?
        target.succeed("""
          mkdir /root/my-config
          mv /etc/nixos/hardware-configuration.nix /root/my-config/
          rm /etc/nixos/configuration.nix
        """)
        target.copy_from_host_via_shell(
          "${
            makeConfig {
              inherit
                bootLoader
                grubDevice
                grubIdentifier
                grubUseEfi
                extraConfig
                clevisTest
                ;
              forceGrubReinstallCount = 1;
              withTestInstrumentation = false;
            }
          }",
          "/root/my-config/configuration.nix",
        )
        target.copy_from_host_via_shell(
          "${./installer/flake.nix}",
          "/root/my-config/flake.nix",
        )
        target.succeed("""
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
        target.succeed("nixos-rebuild switch --flake /root/my-config#xyz 2>&1 | tee activation-log >&2")

        target.succeed("""
          cat -n activation-log >&2
        """)

        target.succeed("""
          grep -F '/root/.nix-defexpr/channels exists, but channels have been disabled.' activation-log
        """)
        target.succeed("""
          grep -F '/nix/var/nix/profiles/per-user/root/channels exists, but channels have been disabled.' activation-log
        """)
        target.succeed("""
          grep -F '/root/.nix-defexpr/channels exists, but channels have been disabled.' activation-log
        """)
        target.succeed("""
          grep -F 'Due to https://github.com/NixOS/nix/issues/9574, Nix may still use these channels when NIX_PATH is unset.' activation-log
        """)
        target.succeed("rm activation-log")

        # Perform the suggested cleanups we've just seen in the log
        # TODO after https://github.com/NixOS/nix/issues/9574: don't remove them yet
        target.succeed("""
          rm -rf /root/.nix-defexpr/channels /nix/var/nix/profiles/per-user/root/channels /root/.nix-defexpr/channels
        """)


      target.shutdown()

      ${startTarget}

      with subtest("nix-channel command is not available anymore"):
        target.succeed("! which nix-channel")

      # Note that the channel profile is still present on disk, but configured
      # not to be used.
      # TODO after issue https://github.com/NixOS/nix/issues/9574: re-enable this assertion
      # I believe what happens is
      #   - because of the issue, we've removed the `nix-path =` line from nix.conf
      #   - the "backdoor" shell is not a proper session and does not have `NIX_PATH=""` set
      #   - seeing no nix path settings at all, Nix loads its hardcoded default value,
      #     which is unfortunately non-empty
      # Or maybe it's the new default NIX_PATH?? :(
      # with subtest("builtins.nixPath is now empty"):
      #   target.succeed("""
      #     (
      #       set -x;
      #       [[ "[ ]" == "$(nix-instantiate builtins.nixPath --eval --expr)" ]];
      #     )
      #   """)

      with subtest("<nixpkgs> does not resolve"):
        target.succeed("""
          ! nix-instantiate '<nixpkgs>' --eval --expr
        """)

      with subtest("Evaluate flake config in fresh env without nix-channel"):
        target.succeed("nixos-rebuild switch --flake /root/my-config#xyz")

      with subtest("Evaluate flake config in fresh env without channel profiles"):
        target.succeed("""
          (
            exec 1>&2
            rm -vf /root/.nix-channels
            rm -vrf ~/.nix-defexpr
            rm -vrf /nix/var/nix/profiles/per-user/root/channels*
          )
        """)
        target.succeed("nixos-rebuild switch --flake /root/my-config#xyz | tee activation-log >&2")
        target.succeed("cat -n activation-log >&2")
        target.succeed("! grep -F '/root/.nix-defexpr/channels' activation-log")
        target.succeed("! grep -F 'but channels have been disabled' activation-log")
        target.succeed("! grep -F 'https://github.com/NixOS/nix/issues/9574' activation-log")

      target.shutdown()
    '';

  makeInstallerTest =
    name:
    {
      createPartitions,
      postInstallCommands ? "",
      postBootCommands ? "",
      extraConfig ? "",
      extraInstallerConfig ? { },
      bootLoader ? "grub", # either "grub" or "systemd-boot"
      grubDevice ? "/dev/vda",
      grubIdentifier ? "uuid",
      grubUseEfi ? false,
      enableOCR ? false,
      meta ? { },
      passthru ? { },
      testSpecialisationConfig ? false,
      testFlakeSwitch ? false,
      testByAttrSwitch ? false,
      clevisTest ? false,
      clevisFallbackTest ? false,
      disableFileSystems ? false,
      selectNixPackage ? pkgs: pkgs.nixVersions.stable,
    }:
    let
      isEfi = bootLoader == "systemd-boot" || (bootLoader == "grub" && grubUseEfi);
    in
    makeTest {
      inherit enableOCR passthru;
      name = "installer-" + name;
      meta = {
        # put global maintainers here, individuals go into makeInstallerTest fkt call
        maintainers = (meta.maintainers or [ ]);
        # non-EFI tests can only run on x86
        platforms = mkIf (!isEfi) [
          "x86_64-linux"
          "x86_64-darwin"
          "i686-linux"
        ];
      };
      nodes =
        let
          commonConfig = {
            # builds stuff in the VM, needs more juice
            virtualisation.diskSize = 8 * 1024;
            virtualisation.cores = 8;
            virtualisation.memorySize = 2048;

            # both installer and target need to use the same drive
            virtualisation.diskImage = "./target.qcow2";

            # and the same TPM options
            virtualisation.qemu.options = mkIf (clevisTest) [
              "-chardev socket,id=chrtpm,path=$NIX_BUILD_TOP/swtpm-sock"
              "-tpmdev emulator,id=tpm0,chardev=chrtpm"
              "-device tpm-tis,tpmdev=tpm0"
            ];
          };
        in
        {
          # The configuration of the system used to run "nixos-install".
          installer =
            { config, pkgs, ... }:
            {
              imports = [
                commonConfig
                ../modules/profiles/installation-device.nix
                ../modules/profiles/base.nix
                extraInstallerConfig
                ./common/auto-format-root-device.nix
              ];

              # In systemdStage1, also automatically format the device backing the
              # root filesystem.
              virtualisation.fileSystems."/".autoFormat = systemdStage1;

              boot.initrd.systemd.enable = systemdStage1;

              # Use a small /dev/vdb as the root disk for the
              # installer. This ensures the target disk (/dev/vda) is
              # the same during and after installation.
              virtualisation.emptyDiskImages = [ 512 ];
              virtualisation.rootDevice = "/dev/vdb";

              nix.package = selectNixPackage pkgs;
              hardware.enableAllFirmware = mkForce false;

              # The test cannot access the network, so any packages we
              # need must be included in the VM.
              system.extraDependencies =
                with pkgs;
                [
                  # TODO: Remove this when we can install systems
                  # without `stdenv`.
                  stdenv

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
                  (nixos-rebuild-ng.override {
                    withNgSuffix = false;
                    withReexec = true;
                  })
                  ntp
                  perlPackages.ConfigIniFiles
                  perlPackages.FileSlurp
                  perlPackages.JSON
                  perlPackages.ListCompare
                  perlPackages.XMLLibXML
                  # make-options-doc/default.nix
                  (python3.withPackages (p: [ p.mistune ]))
                  shared-mime-info
                  sudo
                  switch-to-configuration-ng
                  texinfo
                  unionfs-fuse
                  xorg.lndir
                  shellcheck-minimal

                  # Only the out output is included here, which is what is
                  # required to build the NixOS udev rules
                  # See the comment in services/hardware/udev.nix
                  systemdMinimal.out

                  # add curl so that rather than seeing the test attempt to download
                  # curl's tarball, we see what it's trying to download
                  curl
                ]
                ++ optionals (bootLoader == "grub") (
                  let
                    zfsSupport = extraInstallerConfig.boot.supportedFilesystems.zfs or false;
                  in
                  [
                    (pkgs.grub2.override { inherit zfsSupport; })
                    (pkgs.grub2_efi.override { inherit zfsSupport; })
                    pkgs.nixos-artwork.wallpapers.simple-dark-gray-bootloader
                    pkgs.perlPackages.FileCopyRecursive
                    pkgs.perlPackages.XMLSAX
                    pkgs.perlPackages.XMLSAXBase
                  ]
                )
                ++ optionals (bootLoader == "systemd-boot") [
                  pkgs.zstd.bin
                  pkgs.mypy
                  config.boot.bootspec.package
                ]
                ++ optionals clevisTest [ pkgs.klibc ]
                ++ optional systemdStage1 config.system.nixos-init.package;

              nix.settings = {
                substituters = mkForce [ ];
                hashed-mirrors = null;
                connect-timeout = 1;
              };
            };

          target = {
            imports = [ commonConfig ];
            virtualisation.useBootLoader = true;
            virtualisation.useEFIBoot = isEfi;
            virtualisation.useDefaultFilesystems = false;
            virtualisation.efi.keepVariables = false;

            virtualisation.fileSystems."/" = {
              device = "/dev/disk/by-label/this-is-not-real-and-will-never-be-used";
              fsType = "ext4";
            };
          };
        }
        // optionalAttrs clevisTest {
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
        inherit
          bootLoader
          createPartitions
          postInstallCommands
          postBootCommands
          grubDevice
          grubIdentifier
          grubUseEfi
          extraConfig
          testSpecialisationConfig
          testFlakeSwitch
          testByAttrSwitch
          clevisTest
          clevisFallbackTest
          disableFileSystems
          ;
      };
    };

  makeLuksRootTest =
    name: luksFormatOpts:
    makeInstallerTest name {
      createPartitions = ''
        installer.succeed(
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
      postBootCommands = ''
        target.wait_for_text("[Pp]assphrase for")
        target.send_chars("supersecret\n")
      '';
    };

  # The (almost) simplest partitioning scheme: a swap partition and
  # one big filesystem partition.
  simple-test-config = {
    createPartitions = ''
      installer.succeed(
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

  simple-test-config-by-attr = simple-test-config // {
    testByAttrSwitch = true;
  };

  simple-test-config-from-by-attr-to-flake = simple-test-config // {
    testByAttrSwitch = true;
    testFlakeSwitch = true;
  };

  simple-uefi-grub-config = {
    createPartitions = ''
      installer.succeed(
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
    nixpkgs.overlays = [
      (final: super: {
        zfs = super.zfs.overrideAttrs (_: {
          meta.platforms = [ ];
        });
      })
    ];
  };

  mkClevisBcachefsTest =
    {
      fallback ? false,
    }:
    makeInstallerTest "clevis-bcachefs${optionalString fallback "-fallback"}" {
      clevisTest = true;
      clevisFallbackTest = fallback;
      enableOCR = fallback;
      extraInstallerConfig = {
        imports = [ no-zfs-module ];
        boot.supportedFilesystems = [ "bcachefs" ];
        environment.systemPackages = with pkgs; [
          keyutils
          clevis
        ];
      };
      createPartitions = ''
        installer.succeed(
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
      postBootCommands = optionalString fallback ''
        target.wait_for_text("enter passphrase for")
        target.send_chars("password\n")
      '';
    };

  mkClevisLuksTest =
    {
      fallback ? false,
    }:
    makeInstallerTest "clevis-luks${optionalString fallback "-fallback"}" {
      clevisTest = true;
      clevisFallbackTest = fallback;
      enableOCR = fallback;
      extraInstallerConfig = {
        environment.systemPackages = with pkgs; [ clevis ];
      };
      createPartitions = ''
        installer.succeed(
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
      postBootCommands = optionalString fallback ''
        ${
          if systemdStage1 then
            ''
              target.wait_for_text("Please enter")
            ''
          else
            ''
              target.wait_for_text("Passphrase for")
            ''
        }
        target.send_chars("password\n")
      '';
    };

  mkClevisZfsTest =
    {
      fallback ? false,
      parentDataset ? false,
    }:
    makeInstallerTest
      "clevis-zfs${optionalString parentDataset "-parent-dataset"}${optionalString fallback "-fallback"}"
      {
        clevisTest = true;
        clevisFallbackTest = fallback;
        enableOCR = fallback;
        extraInstallerConfig = {
          boot.supportedFilesystems = [ "zfs" ];
          environment.systemPackages = with pkgs; [ clevis ];
        };
        createPartitions = ''
          installer.succeed(
            "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
            + " mkpart primary ext2 1M 100MB"
            + " mkpart primary linux-swap 100M 1024M"
            + " mkpart primary 1024M -1s",
            "udevadm settle",
            "mkswap /dev/vda2 -L swap",
            "swapon -L swap",
        ''
        + optionalString (!parentDataset) ''
          "zpool create -O mountpoint=legacy rpool /dev/vda3",
          "echo -n password | zfs create"
          + " -o encryption=aes-256-gcm -o keyformat=passphrase rpool/root",
        ''
        + optionalString (parentDataset) ''
          "echo -n password | zpool create -O mountpoint=none -O encryption=on -O keyformat=passphrase rpool /dev/vda3",
          "zfs create -o mountpoint=legacy rpool/root",
        ''
        + ''
          "mount -t zfs rpool/root /mnt",
          "mkfs.ext3 -L boot /dev/vda1",
          "mkdir -p /mnt/boot",
          "mount LABEL=boot /mnt/boot",
          "udevadm settle")
        '';
        extraConfig =
          optionalString (!parentDataset) ''
            boot.initrd.clevis.devices."rpool/root".secretFile = "/etc/nixos/clevis-secret.jwe";
          ''
          + optionalString (parentDataset) ''
            boot.initrd.clevis.devices."rpool".secretFile = "/etc/nixos/clevis-secret.jwe";
          ''
          + ''
            boot.zfs.requestEncryptionCredentials = true;


            # Using by-uuid overrides the default of by-id, and is unique
            # to the qemu disks, as they don't produce by-id paths for
            # some reason.
            boot.zfs.devNodes = "/dev/disk/by-uuid/";
            networking.hostId = "00000000";
          '';
        postBootCommands = optionalString fallback ''
          ${
            if systemdStage1 then
              ''
                target.wait_for_text("Enter key for rpool${optionalString (!parentDataset) "/root"}")
              ''
            else
              ''
                target.wait_for_text("Key load error")
              ''
          }
          target.send_chars("password\n")
        '';
      };

in
{

  # !!! `parted mkpart' seems to silently create overlapping partitions.

  # The (almost) simplest partitioning scheme: a swap partition and
  # one big filesystem partition.
  simple = makeInstallerTest "simple" (
    simple-test-config
    // {
      passthru.override = args: makeInstallerTest "simple" (simple-test-config // args);
    }
  );

  switchToFlake = makeInstallerTest "switch-to-flake" simple-test-config-flake;

  switchToByAttr = makeInstallerTest "switch-to-by-attr" simple-test-config-by-attr;

  switchFromByAttrToFlake = makeInstallerTest "switch-from-by-attr-to-flake" simple-test-config-from-by-attr-to-flake;

  # Test cloned configurations with the simple grub configuration
  simpleSpecialised = makeInstallerTest "simpleSpecialised" (
    simple-test-config // specialisation-test-extraconfig
  );

  # Simple GPT/UEFI configuration using systemd-boot with 3 partitions: ESP, swap & root filesystem
  simpleUefiSystemdBoot = makeInstallerTest "simpleUefiSystemdBoot" {
    createPartitions = ''
      installer.succeed(
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
  simpleUefiGrubSpecialisation = makeInstallerTest "simpleUefiGrubSpecialisation" (
    simple-uefi-grub-config // specialisation-test-extraconfig
  );

  # Same as the previous, but now with a separate /boot partition.
  separateBoot = makeInstallerTest "separateBoot" {
    createPartitions = ''
      installer.succeed(
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
      installer.succeed(
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
      installer.succeed(
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
      installer.succeed("umount /mnt/boot")
      installer.succeed("zpool export bpool")
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
      installer.succeed(
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
      installer.succeed(
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
    extraConfig = optionalString systemdStage1 ''
      boot.initrd.services.lvm.enable = true;
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
      installer.succeed(
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
      installer.succeed(
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

      boot.initrd.secrets."/luks.key" = "/etc/nixos/luks.key";
      boot.initrd.luks.devices.crypt =
        { device  = "/dev/vda2";
          keyFile = "/luks.key";
        };
    '';
    enableOCR = true;
    postBootCommands = ''
      target.wait_for_text("Enter passphrase for")
      target.send_chars("supersecret\n")
    '';
  };

  swraid = makeInstallerTest "swraid" {
    createPartitions = ''
      installer.succeed(
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
    postBootCommands = ''
      target.fail("dmesg | grep 'immediate safe mode'")
    '';
  };

  bcache = makeInstallerTest "bcache" {
    createPartitions = ''
      installer.succeed(
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
      installer.succeed(
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
    postBootCommands = ''
      # Enter it wrong once
      target.wait_for_text("enter passphrase for ")
      target.send_chars("wrong\n")
      # Then enter it right.
      target.wait_for_text("enter passphrase for ")
      target.send_chars("password\n")
    '';

    createPartitions = ''
      installer.succeed(
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
      installer.succeed(
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
      installer.succeed(
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
      installer.succeed(
          "sgdisk -Z /dev/vda",
          "sgdisk -n 1:0:+1M -n 2:0:+100M -n 3:0:+1G -N 4 -t 1:ef02 -t 2:8300 "
          + "-t 3:8200 -t 4:8300 -c 2:boot -c 4:root /dev/vda",
          "mkswap /dev/vda3 -L swap",
          "swapon -L swap",
          "mkfs.ext4 -L boot /dev/vda2",
          "mkfs.ext4 -L root /dev/vda4",
      )
      installer.execute(f"ln -s ../../vda2 /dev/disk/by-uuid/{uuid}")
      installer.execute("ln -s ../../vda4 /dev/disk/by-label/root")
      installer.succeed(
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
      installer.succeed(
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
      installer.succeed(
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
      installer.succeed(
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
      installer.succeed(
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
}
// {
  clevisBcachefs = mkClevisBcachefsTest { };
  clevisBcachefsFallback = mkClevisBcachefsTest { fallback = true; };
  clevisLuks = mkClevisLuksTest { };
  clevisLuksFallback = mkClevisLuksTest { fallback = true; };
  clevisZfs = mkClevisZfsTest { };
  clevisZfsFallback = mkClevisZfsTest { fallback = true; };
  clevisZfsParentDataset = mkClevisZfsTest { parentDataset = true; };
  clevisZfsParentDatasetFallback = mkClevisZfsTest {
    parentDataset = true;
    fallback = true;
  };
}
// optionalAttrs systemdStage1 {
  stratisRoot = makeInstallerTest "stratisRoot" {
    createPartitions = ''
      installer.succeed(
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
    extraInstallerConfig =
      { modulesPath, ... }:
      {
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

  gptAutoRoot =
    let
      rootPartType =
        {
          ia32 = "44479540-F297-41B2-9AF7-D131D5F0458A";
          x64 = "4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709";
          arm = "69DAD710-2CE4-4E3C-B16C-21A1D49ABED3";
          aa64 = "B921B045-1DF0-41C3-AF44-4C6F280D3FAE";
        }
        .${pkgs.stdenv.hostPlatform.efiArch};
    in
    makeInstallerTest "gptAutoRoot" {
      disableFileSystems = true;
      createPartitions = ''
        installer.succeed(
          "sgdisk --zap-all /dev/vda",
          "sgdisk --new=1:0:+100M --typecode=0:ef00 /dev/vda", # /boot
          "sgdisk --new=2:0:+1G --typecode=0:8200 /dev/vda", # swap
          "sgdisk --new=3:0:+5G --typecode=0:${rootPartType} /dev/vda", # /
          "udevadm settle",

          "mkfs.vfat /dev/vda1",
          "mkswap /dev/vda2 -L swap",
          "swapon -L swap",
          "mkfs.ext4 -L root /dev/vda3",
          "udevadm settle",

          "mount /dev/vda3 /mnt",
          "mkdir -p /mnt/boot",
          "mount /dev/vda1 /mnt/boot"
        )
      '';
      bootLoader = "systemd-boot";
      extraConfig = ''
        boot.initrd.systemd.root = "gpt-auto";
        boot.initrd.supportedFilesystems = ["ext4"];
      '';
    };
}
