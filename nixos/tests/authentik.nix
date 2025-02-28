{
  lib,
  ...
}:

let
  port = 9000;
in

{
  name = "authentik";
  meta.maintainers = with lib.maintainers; [ pathob ];

  nodes.machine =
    {
      pkgs,
      ...
    }:

    {
      services.authentik = {
        enable = true;
        secretKey = "verysecretkey";
        postgresql.createLocally = true;
        redis.createLocally = true;
        listen.http.port = port;
      };
    };

  testScript = ''
    def authentik_is_up(_) -> bool:
        status, _ = machine.execute("curl --fail http://localhost:${toString port}")
        return status == 0

    machine.start()
    machine.wait_for_unit("authentik.service")
    machine.wait_for_unit("authentik-worker.service")
    machine.wait_for_open_port(${toString port})

    with machine.nested("Waiting for UI to work"):
        retry(authentik_is_up)
  '';
}
