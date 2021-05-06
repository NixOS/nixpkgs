import ./make-test-python.nix ({ pkgs, ...}:
{
  name = "loolwsd";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mmilata srk pacman99 ];
  };

  machine = { ... }:
  {
    services.loolwsd = {
      enable = true;
    };

    virtualisation.diskSize = 3 * 1024;
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("loolwsd.service")
    # XXX:
    machine.succeed("sleep 1m")
    print(machine.succeed("curl -v http://[::1]:9980/hosting/discovery"))
  '';
})
