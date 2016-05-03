{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with import ../lib/qemu-flags.nix;
with pkgs.lib;

let

  iso =
    (import ../lib/eval-config.nix {
      inherit system;
      modules =
        [ ../modules/installer/cd-dvd/installation-cd-minimal.nix
          ../modules/testing/test-instrumentation.nix
          { key = "serial"; }
        ];
    }).config.system.build.isoImage;

  makeBootTest = name: machineConfig:
    makeTest {
      inherit iso;
      name = "boot-" + name;
      nodes = { };
      testScript =
        ''
          my $machine = createMachine({ ${machineConfig}, qemuFlags => '-m 768' });
          $machine->start;
          $machine->waitForUnit("multi-user.target");
          $machine->shutdown;
        '';
    };
in {
    biosCdrom = makeBootTest "bios-cdrom" ''
        cdrom => glob("${iso}/iso/*.iso")
      '';
    biosUsb = makeBootTest "bios-usb" ''
        usb => glob("${iso}/iso/*.iso")
      '';
    uefiCdrom = makeBootTest "uefi-cdrom" ''
        cdrom => glob("${iso}/iso/*.iso"),
        bios => '${pkgs.OVMF}/FV/OVMF.fd'
      '';
    uefiUsb = makeBootTest "uefi-usb" ''
        usb => glob("${iso}/iso/*.iso"),
        bios => '${pkgs.OVMF}/FV/OVMF.fd'
      '';
    netboot = let
      config = (import ../lib/eval-config.nix {
          inherit system;
          modules =
            [ ../modules/installer/netboot/netboot.nix
              ../modules/testing/test-instrumentation.nix
              { key = "serial"; }
            ];
        }).config;
      ipxeScriptDir = pkgs.writeTextFile {
        name = "ipxeScriptDir";
        text = ''
          #!ipxe
          dhcp
          kernel bzImage init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams} console=ttyS0
          initrd initrd
          boot
        '';
        destination = "/boot.ipxe";
      };
      ipxeBootDir = pkgs.symlinkJoin {
        name = "ipxeBootDir";
        paths = [
          config.system.build.netbootRamdisk
          config.system.build.kernel
          ipxeScriptDir
        ];
      };
    in
      makeTest {
        name = "boot-netboot";
        nodes = { };
        testScript =
          ''
            my $machine = createMachine({ qemuFlags => '-boot order=n -net nic,model=e1000 -net user,tftp=${ipxeBootDir}/,bootfile=boot.ipxe -m 2000M' });
            $machine->start;
            $machine->waitForUnit("multi-user.target");
            $machine->shutdown;
          '';
      };
}
