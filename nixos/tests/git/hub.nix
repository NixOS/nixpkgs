import ../make-test-python.nix ({ pkgs, ...} : {
  name = "hub";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  nodes.hub = { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.gitAndTools.hub ];
    };

  testScript =
    ''
      assert "git version ${pkgs.git.version}\nhub version ${pkgs.gitAndTools.hub.version}\n" in hub.succeed("hub version")
      assert "These GitHub commands are provided by hub" in hub.succeed("hub help")
    '';
})
