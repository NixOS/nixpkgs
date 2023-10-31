{ lib, ... }:

{

  name = "activation-nix-channel";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine = {
    nix.channel.enable = true;
  };

  testScript = { nodes, ... }: ''
    assert machine.succeed("cat /root/.nix-channels") == "${nodes.machine.system.defaultChannel} nixos\n"
  '';

}
