{ lib, ... }:
{
  name = "paretosecurity";
  meta.maintainers = [ lib.maintainers.zupo ];

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.paretosecurity.enable = true;
    };

  # very basic test for now, need to add output asserts
  testScript = ''
    machine.wait_until_succeeds("paretosecurity check")
  '';
}
