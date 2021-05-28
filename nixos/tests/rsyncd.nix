import ./make-test-python.nix ({ pkgs, ... }: {
  name = "rsyncd";
  meta.maintainers = with pkgs.lib.maintainers; [ ehmry ];

  nodes.machine.services.rsyncd = {
    enable = true;
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

  testScript = ''
    start_all()
    machine.wait_for_unit("rsyncd")
    machine.succeed("rsync localhost::")
  '';
})
