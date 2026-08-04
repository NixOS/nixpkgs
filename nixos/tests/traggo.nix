{ lib, ... }:
{
  name = "traggo";
  meta.maintainers = with lib.maintainers; [ elnudev ];

  nodes = {
    basic.services.traggo.enable = true;

    configured = {
      environment.etc."traggo-secret".text = "TRAGGO_DEFAULT_USER_PASS=fromfile\n";
      services.traggo = {
        enable = true;
        environment.TRAGGO_PORT = 8080;
        environmentFiles = [ "/etc/traggo-secret" ];
      };
    };

    lowport.services.traggo = {
      enable = true;
      environment.TRAGGO_PORT = 80;
    };
  };

  testScript = ''
    import json
    import shlex

    def gql(port, query):
        body = shlex.quote(json.dumps({"query": query}))
        return (
            "curl -sf -X POST -H 'Content-Type: application/json' "
            f"-d {body} http://localhost:{port}/graphql"
        )

    def login(port, user, password):
        return gql(port, (
            f'mutation{{login(username:"{user}",pass:"{password}",'
            'deviceName:"t",type:NoExpiry,cookie:false){token}}'
        ))

    start_all()

    with subtest("upstream defaults are respected"):
        basic.wait_for_unit("traggo.service")
        basic.wait_for_open_port(3030)
        basic.succeed("test -f /var/lib/traggo/data/traggo.db")
        basic.succeed("curl -sf http://localhost:3030/ | grep -q '<title>Traggo</title>'")
        basic.succeed(login(3030, "admin", "admin") + " | grep -q token")

    with subtest("environment and environmentFiles are honored"):
        configured.wait_for_unit("traggo.service")
        configured.wait_for_open_port(8080)
        configured.succeed(login(8080, "admin", "fromfile") + " | grep -q token")
        configured.fail(login(8080, "admin", "admin") + " | grep -q token")

    with subtest("privileged ports work"):
        lowport.wait_for_unit("traggo.service")
        lowport.wait_for_open_port(80)
  '';
}
