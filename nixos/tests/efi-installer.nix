# !!! Merge into normal install tests once all livecds are EFIable
{ pkgs, system, ... }:

with pkgs.lib;
with import ../lib/qemu-flags.nix;

let

  # Build the ISO.  This is the regular installation CD but with test
  # instrumentation.
  iso =
    (import ../lib/eval-config.nix {
      inherit system;
      modules =
        [ ../modules/installer/cd-dvd/installation-cd-efi.nix
          ../modules/testing/test-instrumentation.nix
          { key = "serial";

            # The test cannot access the network, so any sources we
            # need must be included in the ISO.
            isoImage.storeContents =
              [ pkgs.glibcLocales
                pkgs.sudo
                pkgs.docbook5
                pkgs.docbook5_xsl
                pkgs.grub
                pkgs.perlPackages.XMLLibXML
                pkgs.unionfs-fuse
                pkgs.gummiboot
                pkgs.libxslt
              ];
          }
        ];
    }).config.system.build.isoImage;


  # The config to install
  config = builtins.toFile "configuration.nix" ''
    { pkgs, ... }: {
      imports = [ ./hardware.nix <nixos/modules/testing/test-instrumentation.nix> ];
      boot.kernelPackages = pkgs.linuxPackages_3_10;
      boot.loader.grub.enable = false;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.gummiboot.enable = true;
      fonts.enableFontConfig = false;
      fileSystems."/".label = "nixos";
    }
  '';

  biosDir = pkgs.runCommand "ovmf-bios" {} ''
    mkdir $out
    ln -s ${pkgs.OVMF}/FV/OVMF.fd $out/bios.bin
  '';

in {
  simple = {
    inherit iso;
    nodes = {};
    testScript = ''
      createDisk("harddisk", 4 * 1024);

      my $machine = createMachine({ hda => "harddisk",
        hdaInterface => "virtio",
        cdrom => glob("${iso}/iso/*.iso"),
        qemuFlags => '-L ${biosDir} ${optionalString (pkgs.stdenv.system == "x86_64-linux") "-cpu kvm64"}'});
      $machine->start;

      # Make sure that we get a login prompt etc.
      $machine->succeed("echo hello");
      $machine->waitForUnit("rogue");
      $machine->waitForUnit("nixos-manual");
      $machine->waitForUnit("dhcpcd");

      # Partition the disk.
      $machine->succeed(
          "sgdisk -Z /dev/vda",
          "sgdisk -n 1:0:+256M -N 2 -t 1:ef00 -t 2:8300 -c 1:boot -c 2:root /dev/vda",
          "mkfs.vfat -n BOOT /dev/vda1",
          "mkfs.ext3 -L nixos /dev/vda2",
          "mount LABEL=nixos /mnt",
          "mkdir /mnt/boot",
          "mount LABEL=BOOT /mnt/boot",
      );

      # Create the NixOS configuration.
      $machine->succeed(
          "mkdir -p /mnt/etc/nixos",
          "nixos-hardware-scan > /mnt/etc/nixos/hardware.nix",
      );

      my $cfg = $machine->succeed("cat /mnt/etc/nixos/hardware.nix");
      print STDERR "Result of the hardware scan:\n$cfg\n";

      $machine->copyFileFromHost(
          "${config}",
          "/mnt/etc/nixos/configuration.nix");

      # Perform the installation.
      $machine->succeed("nixos-install >&2");

      # Do it again to make sure it's idempotent.
      $machine->succeed("nixos-install >&2");

      $machine->shutdown;

      # Now see if we can boot the installation.
      my $machine = createMachine({ #hda => "harddisk",
#       hdaInterface => "virtio",
#       !!! OVMF doesn't boot from virtio http://www.mail-archive.com/edk2-devel@lists.sourceforge.net/msg01501.html
        qemuFlags => '-L ${biosDir} ${optionalString (pkgs.stdenv.system == "x86_64-linux") "-cpu kvm64"} -m 512 -hda ' . Cwd::abs_path('harddisk')});

      # Did /boot get mounted, if appropriate?
      $machine->waitForUnit("local-fs.target");
      $machine->succeed("test -e /boot/efi");

      $machine->succeed("nix-env -i coreutils >&2");
      $machine->succeed("type -tP ls | tee /dev/stderr") =~ /.nix-profile/
          or die "nix-env failed";

      $machine->succeed("nixos-rebuild switch >&2");

      $machine->shutdown;

      my $machine = createMachine({ #hda => "harddisk",
#       hdaInterface => "virtio",
        qemuFlags => '-L ${biosDir} ${optionalString (pkgs.stdenv.system == "x86_64-linux") "-cpu kvm64"} -hda ' . Cwd::abs_path('harddisk')});
      $machine->waitForUnit("network.target");
      $machine->shutdown;
    '';
  };
}
