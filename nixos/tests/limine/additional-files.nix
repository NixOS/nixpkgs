{ pkgs, lib, ... }:
{
  name = "additionalFiles";
  meta.maintainers = with lib.maintainers; [
    flokli
  ];
  meta.platforms = [
    "x86_64-linux"
  ];
  nodes.machine =
    { ... }:
    {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;
      boot.loader.limine.enable = true;
      boot.loader.limine.efiSupport = true;
      boot.loader.timeout = 0;

      specialisation.withAdditionalFiles.configuration = { ... }: {
        boot.loader.limine.additionalFiles = {
          "efi/memtest86/memtest86.efi" = "${pkgs.memtest86-efi}/BOOTX64.efi";
        };
      };
      specialisation.withAdditionalFilesOther.configuration = { ... }: {
        boot.loader.limine.additionalFiles = {
          "efi/memtest86/memtest86.efi" = "${builtins.toFile "some-file" "some-content"}";
        };
      };
    };

  testScript =
    { nodes, ... }:
    let
      withAdditionalFiles =
        nodes.machine.specialisation.withAdditionalFiles.configuration.system.build.toplevel;
      withAdditionalFilesOther =
        nodes.machine.specialisation.withAdditionalFilesOther.configuration.system.build.toplevel;
    in
    ''
      machine.start()
      machine.wait_for_unit("multi-user.target")

      # switch to a generation with additional files and ensure they're present
      machine.succeed("${withAdditionalFiles}/bin/switch-to-configuration switch")
      machine.succeed("stat /boot/efi/memtest86/memtest86.efi")

      # switch to the next generation with something else in there and ensure it got updated
      machine.succeed("${withAdditionalFilesOther}/bin/switch-to-configuration switch")
      assert machine.succeed("cat /boot/efi/memtest86/memtest86.efi").strip() == "some-content"
    '';
}
