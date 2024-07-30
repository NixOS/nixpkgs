import ./make-test-python.nix ({ pkgs, ...} : {
  name = "nzbget";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ aanderse flokli ];
  };

  nodes = {
    server = { ... }: {
      services.nzbget.enable = true;

      # provide some test settings
      services.nzbget.settings = {
        "MainDir" = "/var/lib/nzbget";
        "DirectRename" = true;
        "DiskSpace" = 0;
        "Server1.Name" = "this is a test";
      };

      # hack, don't add (unfree) unrar to nzbget's path,
      # so we can run this test in CI
      systemd.services.nzbget.path = pkgs.lib.mkForce [ pkgs.p7zip ];
    };
  };

  testScript = { nodes, ... }: ''
    start_all()

    server.wait_for_unit("nzbget.service")
    server.wait_for_unit("network.target")
    server.wait_for_open_port(6789)
    assert "This file is part of nzbget" in server.succeed(
        "curl -f -s -u nzbget:tegbzn6789 http://127.0.0.1:6789"
    )
    server.succeed(
        "${pkgs.nzbget}/bin/nzbget -n -o Control_iP=127.0.0.1 -o Control_port=6789 -o Control_password=tegbzn6789 -V"
    )

    config = server.succeed("${nodes.server.systemd.services.nzbget.serviceConfig.ExecStart} --printconfig")

    # confirm the test settings are applied
    assert 'MainDir = "/var/lib/nzbget"' in config
    assert 'DirectRename = "yes"' in config
    assert 'DiskSpace = "0"' in config
    assert 'Server1.Name = "this is a test"' in config
  '';
})
