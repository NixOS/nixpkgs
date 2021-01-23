import ./make-test-python.nix ({ pkgs, ... }: {
  name = "lsd";
  meta = with pkgs.lib.maintainers; { maintainers = [ nequissimus ]; };

  nodes.lsd = { pkgs, ... }: { environment.systemPackages = [ pkgs.lsd ]; };

  testScript = ''
    lsd.succeed('echo "abc" > /tmp/foo')
    assert "4 B /tmp/foo" in lsd.succeed('lsd --classic --blocks "size,name" -l /tmp/foo')
    assert "lsd ${pkgs.lsd.version}" in lsd.succeed("lsd --version")
  '';
})
