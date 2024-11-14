{ lib, ... }:

{

  name = "activation-nix-channel";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine = {
    nix.channel.enable = true;
  };

  testScript = { nodes, ... }: ''
    machine.start(allow_reboot=True)

    assert machine.succeed("cat /root/.nix-channels") == "${nodes.machine.system.defaultChannel} nixos\n"

    nixpkgs_unstable_channel = "https://nixos.org/channels/nixpkgs-unstable nixpkgs"
    machine.succeed(f"echo '{nixpkgs_unstable_channel}' > /root/.nix-channels")

    machine.reboot()

    assert machine.succeed("cat /root/.nix-channels") == f"{nixpkgs_unstable_channel}\n"
  '';

}
