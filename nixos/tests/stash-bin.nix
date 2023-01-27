import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "stash";
  meta = with pkgs.lib; {
    maintainers = with maintainers; [ airradda ];
  };

  nodes.machine = { pkgs, ... }: {
    services.stash = {
      enable = true;
    };
  };

  testScript = ''
    machine.wait_for_unit("stash.service")
    machine.wait_until_succeeds(
        "curl --fail -L http://localhost:9999/"
    )
  '';
})
