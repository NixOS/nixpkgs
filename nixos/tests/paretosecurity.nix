{ lib, ... }:
{
  name = "paretosecurity";
  meta.maintainers = [ lib.maintainers.zupo ];

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.paretosecurity.enable = true;
    };

  testScript = ''
    (status, out) = machine.execute("paretosecurity check")
    assert status == 1, "paretosecurity did not return 1 on failing checks"
  '';
}
