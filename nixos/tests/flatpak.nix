# run installed tests
import ./make-test.nix ({ pkgs, ... }:

{
  name = "flatpak";
  meta = {
    maintainers = pkgs.flatpak.meta.maintainers;
  };

  machine = { config, pkgs, ... }: {
    imports = [ ./common/x11.nix ];
    services.xserver.desktopManager.gnome3.enable = true; # TODO: figure out minimal environment where the tests work
    services.flatpak.enable = true;
    environment.systemPackages = with pkgs; [ gnupg gnome-desktop-testing ostree python2 ];
    virtualisation.memorySize = 2047;
    virtualisation.diskSize = 1024;
  };

  testScript = ''
    $machine->waitForX();
    $machine->succeed("gnome-desktop-testing-runner -d '${pkgs.flatpak.installedTests}/share' --timeout 3600");
  '';
})
