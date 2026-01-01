{ pkgs, ... }:
{
  name = "hub";
<<<<<<< HEAD
=======
  meta = with pkgs.lib.maintainers; {
    maintainers = [ nequissimus ];
  };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
