{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing.nix { inherit system pkgs; };
with pkgs.lib;

let

  iso =
    (import ../lib/eval-config.nix {
      inherit system;
      modules =
        [ ../modules/installer/cd-dvd/installation-cd-minimal.nix
          ../modules/testing/test-instrumentation.nix
        ];
    }).config.system.build.isoImage;

  perlAttrs = params: "{ ${concatStringsSep ", " (mapAttrsToList (name: param: "${name} => ${builtins.toJSON param}") params)} }";

  makeBootTest = name: extraConfig:
    let
      machineConfig = perlAttrs ({ qemuFlags = "-m 768"; } // extraConfig);
    in
      makeTest {
        inherit iso;
        name = "boot-" + name;
        nodes = { };
        testScript =
          ''
            my $machine = createMachine(${machineConfig});
            $machine->start;
            $machine->waitForUnit("multi-user.target");
            $machine->succeed("nix verify -r --no-trust /run/current-system");

            # Test whether the channel got installed correctly.
            $machine->succeed("nix-instantiate --dry-run '<nixpkgs>' -A hello");
            $machine->succeed("nix-env --dry-run -iA nixos.procps");

            $machine->shutdown;
          '';
      };

  makeNetbootTest = name: extraConfig:
    let
      config = (import ../lib/eval-config.nix {
          inherit system;
          modules =
            [ ../modules/installer/netboot/netboot.nix
              ../modules/testing/test-instrumentation.nix
              { key = "serial"; }
            ];
        }).config;
      ipxeBootDir = pkgs.symlinkJoin {
        name = "ipxeBootDir";
        paths = [
          config.system.build.netbootRamdisk
          config.system.build.kernel
          config.system.build.netbootIpxeScript
        ];
      };
      machineConfig = perlAttrs ({
        qemuFlags = "-boot order=n -m 2000";
        netBackendArgs = "tftp=${ipxeBootDir},bootfile=netboot.ipxe";
      } // extraConfig);
    in
      makeTest {
        name = "boot-netboot-" + name;
        nodes = { };
        testScript =
          ''
            my $machine = createMachine(${machineConfig});
            $machine->start;
            $machine->waitForUnit("multi-user.target");
            $machine->shutdown;
          '';
      };
in {

    biosCdrom = makeBootTest "bios-cdrom" {
      cdrom = "${iso}/iso/${iso.isoName}";
    };

    biosUsb = makeBootTest "bios-usb" {
      usb = "${iso}/iso/${iso.isoName}";
    };

    uefiCdrom = makeBootTest "uefi-cdrom" {
      cdrom = "${iso}/iso/${iso.isoName}";
      bios = "${pkgs.OVMF.fd}/FV/OVMF.fd";
    };

    uefiUsb = makeBootTest "uefi-usb" {
      usb = "${iso}/iso/${iso.isoName}";
      bios = "${pkgs.OVMF.fd}/FV/OVMF.fd";
    };

    biosNetboot = makeNetbootTest "bios" {};

    uefiNetboot = makeNetbootTest "uefi" {
      bios = "${pkgs.OVMF.fd}/FV/OVMF.fd";
      # Custom ROM is needed for EFI PXE boot. I failed to understand exactly why, because QEMU should still use iPXE for EFI.
      netFrontendArgs = "romfile=${pkgs.ipxe}/ipxe.efirom";
    };
}
