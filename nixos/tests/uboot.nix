{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:
let
  testing = import ../lib/testing-python.nix { inherit system pkgs; };
  makeBiosBin = pkg: pkgs.runCommand "u-boot.rom" {}
  ''
    mkdir $out
    cp ${pkg}/u-boot.rom $out/bios.bin
  '';
  biosBin = makeBiosBin pkgs.ubootQemuX86;
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

  # test for boot.loader.timeout = null
  # which should cause uboot to display menu
  # until selection is made
  extlinuxNullTimeout = testing.makeTest {
    name = "ubootExtlinuxNullTimeout";

    nodes.machine = { ... }: {
      boot.loader.grub.enable = false;
      boot.loader.generic-extlinux-compatible.enable = true;
      boot.loader.timeout = null;

      virtualisation.bios = biosBin;
      virtualisation.useBootLoader = true;
      virtualisation.qemu.options = [ "-accel tcg" ];
    };

    testScript =
      ''
        start_all()
        machine.wait_for_console_text("NixOS - Default")
        machine.send_monitor_command("sendkey 1")
        machine.send_monitor_command("sendkey ret")
        machine.wait_for_unit("multi-user.target")
      '';
  };

  # test for boot.loader.timeout = 0
  # which should cause uboot to skip menu
  # and boot instantly
  extlinuxZeroTimeout = testing.makeTest {
    name = "ubootExtlinuxZeroTimeout";

    nodes.machine = { ... }:
    let
      # we use a customized uboot here
      # that won't allow breaking boot w/o Ctrl-C
      unbreakable = pkgs.ubootQemuX86.override {
        extraConfig =
          pkgs.ubootQemuX86.extraConfig +
          ''
            CONFIG_BOOTDELAY=0
            CONFIG_AUTOBOOT_KEYED=y
            CONFIG_AUTOBOOT_KEYED_CTRLC=y
            CONFIG_AUTOBOOT_PROMPT="Hit Ctrl-C to abort in %d\n"
          '';
      };
      unbreakableBiosBin = makeBiosBin unbreakable;
    in
    {
      boot.loader.grub.enable = false;
      boot.loader.generic-extlinux-compatible.enable = true;
      boot.loader.timeout = 0;

      virtualisation.bios = unbreakableBiosBin;
      virtualisation.useBootLoader = true;
      virtualisation.qemu.options = [ "-accel tcg" ];
    };

    testScript =
      ''
        start_all()
        for i in range(100):
          machine.send_monitor_command("sendkey ret")
        machine.wait_for_unit("multi-user.target")
      '';
  };

}
