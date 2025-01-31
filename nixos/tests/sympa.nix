import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "sympa";
  meta.maintainers = with lib.maintainers; [ mmilata ];

  nodes.machine =
    { ... }:
    {

      services.sympa = {
        enable = true;
        domains = {
          "lists.example.org" = {
            webHost = "localhost";
          };
        };
        listMasters = [ "bob@example.org" ];
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
        "curl --fail --insecure -L http://localhost/"
    )
  '';
})
