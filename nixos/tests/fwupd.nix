# run installed tests
import ./make-test.nix ({ pkgs, ... }: {
  name = "fwupd";

  meta = {
    maintainers = pkgs.fwupd.meta.maintainers;
  };

  machine = { pkgs, ... }: {
    services.fwupd.enable = true;
    services.fwupd.blacklistPlugins = []; # don't blacklist test plugin
    services.fwupd.enableTestRemote = true;
    environment.systemPackages = with pkgs; [ gnome-desktop-testing ];
    environment.variables.XDG_DATA_DIRS = [ "${pkgs.fwupd.installedTests}/share" ];
    virtualisation.memorySize = 768;
  };

  testScript = ''
    $machine->succeed("gnome-desktop-testing-runner");
  '';
})
