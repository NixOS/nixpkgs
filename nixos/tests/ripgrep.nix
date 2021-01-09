import ./make-test-python.nix ({ pkgs, ... }: {
  name = "ripgrep";
  meta = with pkgs.stdenv.lib.maintainers; { maintainers = [ nequissimus ]; };

  nodes.ripgrep = { pkgs, ... }: { environment.systemPackages = [ pkgs.ripgrep ]; };

  testScript = ''
    ripgrep.succeed('echo "abc\nbcd\ncde" > /tmp/foo')
    assert "bcd" in ripgrep.succeed("rg -N 'bcd' /tmp/foo")
    assert "bcd\ncde" in ripgrep.succeed("rg -N 'cd' /tmp/foo")
    assert "ripgrep ${pkgs.ripgrep.version}" in ripgrep.succeed("rg --version | head -1")
  '';
})
