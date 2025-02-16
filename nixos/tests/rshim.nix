{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

{
  basic = makeTest {
    name = "rshim";
    meta.maintainers = with maintainers; [ nikstur ];

    nodes.machine =
      { config, pkgs, ... }:
      {
        services.rshim.enable = true;
      };

    testScript =
      { nodes, ... }:
      ''
        machine.start()
        machine.wait_for_unit("multi-user.target")

        print(machine.succeed("systemctl status rshim.service"))
      '';
  };
}
