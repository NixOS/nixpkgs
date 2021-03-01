import ./make-test-python.nix ({ pkgs, ... }: {
  name = "ucg";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ AndersonTorres ];
  };

  machine = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.ucg ];
  };

  testScript = ''
    machine.succeed("echo 'Lorem ipsum dolor sit amet\n2.7182818284590' > /tmp/foo")
    assert "dolor" in machine.succeed("ucg 'dolor' /tmp/foo")
    assert "Lorem" in machine.succeed("ucg --ignore-case 'lorem' /tmp/foo")
    machine.fail("ucg --word-regexp '2718' /tmp/foo")
    machine.fail("ucg 'pisum' /tmp/foo")
  '';
})
