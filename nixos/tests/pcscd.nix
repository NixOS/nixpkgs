import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "pcscd";
    meta.maintainers = [ lib.maintainers.anthonyroussel ];

    nodes = {
      pcscd =
        { ... }:
        {
          services.pcscd.enable = true;
          security.polkit.enable = true;
        };
    };

    testScript = ''
      start_all()

      pcscd.succeed("systemctl start pcscd")
      pcscd.wait_for_unit("pcscd.service")
      pcscd.wait_for_file("/run/pcscd/pcscd.pid")
    '';
  }
)
