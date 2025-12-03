{ lib, pkgs, ... }:
{
  name = "secureBoot";
  meta = {
    inherit (pkgs.limine.meta) maintainers;
  };

  meta.platforms = [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
  ];
  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;
      virtualisation.useSecureBoot = true;
      virtualisation.efi.OVMF = pkgs.OVMFFull.fd;
      virtualisation.efi.keepVariables = true;

      boot.loader.efi.canTouchEfiVariables = true;

      boot.loader.limine.enable = true;
      boot.loader.limine.efiSupport = true;
      boot.loader.limine.secureBoot.enable = true;
      boot.loader.limine.secureBoot.createAndEnrollKeys = true;
      boot.loader.timeout = 0;

      environment.systemPackages = [ pkgs.mokutil ];
    };

  testScript = ''
    machine.start()
    assert "SecureBoot enabled" in machine.succeed("mokutil --sb-state")
  '';
}
