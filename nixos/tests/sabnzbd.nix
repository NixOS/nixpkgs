import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "sabnzbd";
  meta = with pkgs.lib; {
    maintainers = with maintainers; [ jojosch ];
  };

  nodes.machine = { pkgs, ... }: {
    services.sabnzbd = {
      enable = true;
    };

    # unrar is unfree
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "unrar" ];
  };

  testScript = ''
    machine.wait_for_unit("sabnzbd.service")
    machine.wait_until_succeeds(
        "curl --fail -L http://localhost:8080/"
    )
  '';
})
