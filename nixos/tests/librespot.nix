import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "librespot";
  meta.maintainers = with lib.maintainers; [ Scriptkiddi ];

  machine =
    { ... }:
    {

      services.librespot = {
        enable = true;
        name = "spotify test";
        zeroconfPort = 15353;
      };
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("librespot.service")
    machine.succeed("curl --insecure -L http://localhost:15353")
  '';
})
