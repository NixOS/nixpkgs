{ pkgs, ... }:
{
  name = "bpfman";
  meta.maintainers = with pkgs.lib.maintainers; [ pizzapim ];

  nodes.machine =
    { ... }:
    {
      services.bpfman.enable = true;
    };

  testScript = ''
    machine.succeed("bpfman list | grep Program")
  '';
}
