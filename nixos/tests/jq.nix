import ./make-test-python.nix ({ pkgs, ... }: {
  name = "jq";
  meta = with pkgs.lib.maintainers; { maintainers = [ nequissimus ]; };

  nodes.jq = { pkgs, ... }: { environment.systemPackages = [ pkgs.jq ]; };

  testScript = ''
    assert "world" in jq.succeed('echo \'{"values":["hello","world"]}\'| jq \'.values[1]\''')
  '';
})
