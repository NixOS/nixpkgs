import ./make-test-python.nix ({ pkgs, ...} : {
  name = "nzbget";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ aanderse flokli ];
  };

  nodes = {
    server = { ... }: {
      services.nzbget.enable = true;

      # hack, don't add (unfree) unrar to nzbget's path,
      # so we can run this test in CI
      systemd.services.nzbget.path = pkgs.stdenv.lib.mkForce [ pkgs.p7zip ];
    };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("nzbget.service")
    server.wait_for_unit("network.target")
    server.wait_for_open_port(6789)
    assert "This file is part of nzbget" in server.succeed(
        "curl -s -u nzbget:tegbzn6789 http://127.0.0.1:6789"
    )
    server.succeed(
        "${pkgs.nzbget}/bin/nzbget -n -o Control_iP=127.0.0.1 -o Control_port=6789 -o Control_password=tegbzn6789 -V"
    )
  '';
})
