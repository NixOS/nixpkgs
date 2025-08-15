{
  lib,
  pkgs,
  ...
}:
{
  name = "jaq";

  meta.maintainers = with lib.maintainers; [ ethancedwards8 ];

  nodes.machine = {
    environment.systemPackages = with pkgs; [ jaq ];
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      # checking if 1 + 2 == 3.
      machine.succeed('[ "$(echo \'{"a": 1, "b": 2}\' | jaq \'add\')" -eq 3 ]')

      # echo out 0-3, map over them multiplying by 2, keep all elements under 5, add the results up together. Should be 6
      machine.succeed('[ "$(echo \'[0, 1, 2, 3]\' | jaq \'map(.*2) | [.[] | select(. < 5)] | add\')" -eq 6 ]')

      # fail on malformed input
      machine.fail('echo "0, 1, 4, " | jaq')
    '';
}
