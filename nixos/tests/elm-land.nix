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
    machine.succeeds("elm-land --version | grep '0.20.1'")
  '';
}
