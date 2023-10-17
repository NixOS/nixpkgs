{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:
let
  testing = import ../lib/testing-python.nix { inherit system pkgs; };
  biosBin = pkgs.runCommand "u-boot.rom" {}
  ''
    mkdir $out
    cp ${pkgs.ubootQemuX86}/u-boot.rom $out/bios.bin
  '';
in {
  extlinuxSimple = testing.makeTest {
    name = "ubootExtlinuxSimple";

    nodes.machine = { ... }: {
      boot.loader.grub.enable = false;
      boot.loader.generic-extlinux-compatible.enable = true;

      virtualisation.bios = biosBin;
      virtualisation.useBootLoader = true;
      virtualisation.qemu.options = [ "-accel tcg" ];
    };

    testScript =
      ''
        start_all()
        machine.wait_for_unit("multi-user.target")
      '';
  };

  extlinuxSD = testing.makeTest {
    name = "ubootExtlinuxSD";

    nodes.machine = { ... }:

    {
      virtualisation.bios = biosBin;
      virtualisation.qemu.options = [ "-accel tcg" ];
    };

    testScript =
    let
      sd =
        (import ../lib/eval-config.nix {
          inherit system;
          modules = [
            ../modules/installer/sd-card/sd-image-x86_64.nix
            ../modules/testing/test-instrumentation.nix
            { sdImage.compressImage = false; }
          ];
        }).config.system.build.sdImage;
      sdImage = "${sd}/sd-image/${sd.imageName}";
      mutableImage = "/tmp/linked-image.qcow2";
    in
      ''
        import os
        if os.system("qemu-img create -f qcow2 -F raw -b ${sdImage} ${mutableImage}") != 0:
            raise RuntimeError("Could not create mutable linked image")
        os.environ['NIX_DISK_IMAGE'] = '${mutableImage}'
        start_all()
        machine.wait_for_unit("multi-user.target")
      '';
  };
}
