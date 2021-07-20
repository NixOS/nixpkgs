import ./make-test-python.nix ({ pkgs, ... }: {
  name = "etesync-web";
  meta = with pkgs.lib; {
    maintainers = with maintainers; [ pacman99 ];
  };
  machine = { ... }: {
    services.etesync-web = {
      enable = true;
      hostName = "localhost";
    };
  };
  testScript = ''
    machine.wait_for_unit("nginx.service")
    machine.wait_for_unit("multi-user.target")
    assert "EteSync - Secure Data Sync" in machine.succeed("curl http://localhost")
  '';
})
