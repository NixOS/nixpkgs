{ ... }:
{
  name = "fittrackee";
  nodes = {
    base =
      { ... }:
      {
        services = {
          fittrackee = {
            enable = true;
            database.createDatabase = true;
          };
        };
      };
    with-redis = { ... }: {
      services = {
        fittrackee = {
          enable = true;
          database.createDatabase = true;
          redis = {
            enable = true;
            createLocally = true;
          };
        };
      };
    };
  };

  # https://nixos.org/manual/nixos/stable/index.html#ssec-machine-objects
  testScript = ''
    start_all()
    for node in [base, with_redis]:
      node.wait_for_unit("postgresql.service")
      node.wait_for_unit("fittrackee.service")
      node.wait_for_open_port(8000)
      node.execute("curl http://127.0.0.1:8000")
  '';
}
