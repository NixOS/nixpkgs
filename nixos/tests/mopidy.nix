{ pkgs, ... }:
{
  name = "mopidy";

  nodes.machine =
    { ... }:
    {
      services.mopidy.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("mopidy")
    machine.wait_for_open_port(6680)
  '';
}
