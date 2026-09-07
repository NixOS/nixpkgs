{ pkgs, ... }:
{
  name = "hub";

  nodes.hub =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.hub ];
    };

  testScript = ''
    assert "git version ${pkgs.git.version}\nhub version ${pkgs.hub.version}\n" in hub.succeed("hub version")
    assert "These GitHub commands are provided by hub" in hub.succeed("hub help")
  '';
}
