import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "sympa";
  meta.maintainers = with lib.maintainers; [ mmilata ];

  machine =
    { ... }:
    {
      virtualisation.memorySize = 1024;

      services.sympa = {
        enable = true;
        domains = {
          "lists.example.org" = {
            webHost = "localhost";
          };
        };
        listMasters = [ "joe@example.org" ];
        web.enable = true;
        web.https = false;
        database = {
          type = "PostgreSQL";
          createLocally = true;
        };
      };
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("sympa.service")
    machine.wait_for_unit("wwsympa.service")
    assert "Mailing lists service" in machine.succeed(
        "curl --insecure -L http://localhost/"
    )
  '';
})
