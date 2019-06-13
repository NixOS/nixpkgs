# run installed tests
import ./make-test.nix ({ pkgs, ... }:

{
  name = "flatpak";
  meta = {
    maintainers = pkgs.flatpak.meta.maintainers;
  };

  machine = { pkgs, ... }: {
    imports = [ ./common/x11.nix ];
    services.xserver.desktopManager.gnome3.enable = true; # TODO: figure out minimal environment where the tests work
    # common/x11.nix enables the auto display manager (lightdm)
    services.xserver.displayManager.gdm.enable = false;
    environment.gnome3.excludePackages = pkgs.gnome3.optionalPackages;
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
