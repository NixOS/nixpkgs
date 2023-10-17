{ lib, ... }:

{

  name = "activation-nix-channel";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine = {
    nix.channel.enable = true;
  };

  testScript = ''
    print(machine.succeed("cat /root/.nix-channels"))
  '';
}
