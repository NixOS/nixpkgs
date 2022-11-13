# This test runs terminusdb and checks if terminusdb is up and running

import ./make-test-python.nix ({ pkgs, ...} : {
  name = "terminusdb";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ offline ];
  };

  nodes = {
    one = { ... }: {
      services.terminusdb.enable = true;
      environment.systemPackages = [ pkgs.httpie ];
    };
  };

  testScript = ''
    start_all()

    one.wait_for_unit("terminusdb.service")

    # create database
    one.succeed(
        "curl --fail http://localhost:6363/dashboard/"
    )
  '';
})
