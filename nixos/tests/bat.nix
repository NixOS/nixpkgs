import ./make-test-python.nix ({ pkgs, ... }: {
  name = "bat";
  meta = with pkgs.lib.maintainers; { maintainers = [ nequissimus ]; };

  machine = { pkgs, ... }: { environment.systemPackages = [ pkgs.bat ]; };

  testScript = ''
    machine.succeed("echo 'Foobar\n\n\n42' > /tmp/foo")
    assert "Foobar" in machine.succeed("bat -p /tmp/foo")
    assert "42" in machine.succeed("bat -p /tmp/foo -r 4:4")
  '';
})
