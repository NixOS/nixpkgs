{
  lib,
  pkgs,
  ...
}:

{
  name = "owasp blint test";

  meta.maintainers =
    with lib;
    [
      maintainers.ethancedwards8
    ]
    ++ teams.ngi.members;

  nodes.machine = {
    environment.systemPackages = with pkgs; [
      blint
      jq
    ];
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      machine.succeed('blint -i ${pkgs.ripgrep.exe} -o /tmp/ripgrep')
      machine.succeed('jq . /tmp/ripgrep/*.json')
    '';
}
