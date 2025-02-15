{ lib, ... }:
{
  name = "elm-land";
  meta.maintainers = [ lib.maintainers.zupo ];

  nodes.machine =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.elmPackages.elm-land ];
    };

  testScript = ''
    machine.succeeds("elm-land init foo")
    machine.succeeds("cd foo && elm-land build")
    machine.succeeds("cat foo/dist/index.html | grep '<title>Elm Land</title>'")
  '';
}
