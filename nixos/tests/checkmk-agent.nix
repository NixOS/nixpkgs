{ pkgs, ... }:
{
  name = "checkmk-agent-nixos";
  meta.maintainers = with pkgs.lib.maintainers; [ weriomat ];
  nodes.server =
    { config, ... }:
    {
      services.checkmk-agent.enable = true;
      environment.systemPackages = [ config.services.checkmk-agent.package ];
    };
  testScript = ''
    start_all()
    assert "inoperational" not in server.succeed("cmk-agent-ctl status")
    server.succeed("cmk-agent-ctl dump")
  '';
}
