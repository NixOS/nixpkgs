import ./make-test-python.nix ({ pkgs, ... }: {
  name = "rsyncd";
  meta.maintainers = with pkgs.lib.maintainers; [ ehmry ];

  nodes = let
    mkNode = socketActivated:
      { config, ... }: {
        networking.firewall.allowedTCPPorts = [ config.services.rsyncd.port ];
        services.rsyncd = {
          enable = true;
          inherit socketActivated;
          settings = {
            global = {
              "reverse lookup" = false;
              "forward lookup" = false;
            };
            tmp = {
              path = "/nix/store";
              comment = "test module";
            };
          };
        };
      };
  in {
    a = mkNode false;
    b = mkNode true;
  };

  testScript = ''
    start_all()
    a.wait_for_unit("rsync")
    b.wait_for_unit("sockets.target")
    b.succeed("rsync a::")
    a.succeed("rsync b::")
  '';
})
