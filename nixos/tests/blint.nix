{
  lib,
  pkgs,
  ...
}:

{
  name = "owasp blint test";

<<<<<<< HEAD
  meta.maintainers =
    with lib;
    [
      maintainers.ethancedwards8
    ]
    ++ teams.ngi.members;
=======
  meta.maintainers = with lib; [
    maintainers.ethancedwards8
    teams.ngi
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

      machine.succeed('blint -i ${lib.getExe pkgs.ripgrep} -o /tmp/ripgrep')
      machine.succeed('jq . /tmp/ripgrep/*.json')
    '';
}
