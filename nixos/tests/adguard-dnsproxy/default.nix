import ../make-test-python.nix ({ pkgs, ... }: {
  name = "adguard-dnsproxy";
  meta.maintainers = with pkgs.lib.maintainers; [ ckiee ];

  nodes.server = { ... }: {
    services.adguard-dnsproxy = {
      enable = true;
      fallbacks = [];
      port = 53;
      upstreams = [ "127.0.0.1:1238" ];
    };

    services.coredns = {
      enable = true;
      config = ''
        test:1238 {
          file ${./test.zone}
        }
      '';
    };
  };

  testScript = ''
    server.wait_for_unit("adguard-dnsproxy")
    server.wait_for_open_port("53")
    server.wait_for_unit("coredns")
    server.wait_for_open_port("1238")
    # check reliability
    for i in range(2000):
        server.succeed("${pkgs.dig}/bin/dig @127.0.0.1 +tries=1 test.test")
  '';
})
