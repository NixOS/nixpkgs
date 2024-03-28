import ./make-test-python.nix ({ pkgs, ...}: {
  name = "xpra";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ aforemny ];
  };

  nodes.machine = { ... }: {
    services.xserver.enable = true;
    services.xserver.displayManager.xpra.enable = true;
  };

  testScript = { nodes, ... }: ''
    machine.wait_for_unit("display-manager.service");
    machine.succeed("xpra version :0");
  '';
})
