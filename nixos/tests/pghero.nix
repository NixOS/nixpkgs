let
  pgheroPort = 1337;
  pgheroUser = "pghero";
  pgheroPass = "pghero";
in
{ lib, ... }:
{
  name = "pghero";
  meta.maintainers = [ lib.maintainers.tie ];

  nodes.machine =
    { config, ... }:
    {
      services.postgresql = {
        enable = true;
        # This test uses default peer authentication (socket and its directory is
        # world-readably by default), so we essentially test that we can connect
        # with DynamicUser= set.
        ensureUsers = [
          {
            name = "pghero";
            ensureClauses.superuser = true;
          }
        ];
      };
      services.pghero = {
        enable = true;
        listenAddress = "[::]:${toString pgheroPort}";
        settings = {
          databases = {
            postgres.url = "<%= ENV['POSTGRES_DATABASE_URL'] %>";
            nulldb.url = "nulldb:///";
          };
        };
        environment = {
          PGHERO_USERNAME = pgheroUser;
          PGHERO_PASSWORD = pgheroPass;
          POSTGRES_DATABASE_URL = "postgresql:///postgres?host=/run/postgresql";
        };
      };
    };

  testScript = ''
    pgheroPort = ${toString pgheroPort}
    pgheroUser = "${pgheroUser}"
    pgheroPass = "${pgheroPass}"

    pgheroUnauthorizedURL = f"http://localhost:{pgheroPort}"
    pgheroBaseURL = f"http://{pgheroUser}:{pgheroPass}@localhost:{pgheroPort}"

    def expect_http_code(node, code, url):
        http_code = node.succeed(f"curl -s -o /dev/null -w '%{{http_code}}' '{url}'")
        assert http_code.split("\n")[-1].strip() == code, \
          f"expected HTTP status code {code} but got {http_code}"

    machine.wait_for_unit("postgresql.target")
    machine.wait_for_unit("pghero.service")

    with subtest("requires HTTP Basic Auth credentials"):
      expect_http_code(machine, "401", pgheroUnauthorizedURL)

    with subtest("works with some databases being unavailable"):
      expect_http_code(machine, "500", pgheroBaseURL + "/nulldb")

    with subtest("connects to the PostgreSQL database"):
      expect_http_code(machine, "200", pgheroBaseURL + "/postgres")
  '';
}
