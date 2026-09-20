{ lib, ... }:
{
  name = "checkmate-capture";
  meta.maintainers = with lib.maintainers; [ robertjakub ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.checkmate-capture = {
        enable = true;
        apiSecretFile = "/run/checkmate-capture-api";
      };
    };

  testScript = ''
    machine.start()

    machine.execute("echo \"APIPass\" > /run/checkmate-capture-api && chmod 400 /run/checkmate-capture-api")
    machine.wait_for_unit("checkmate-capture.service")
    machine.wait_for_open_port(59232)

    machine.wait_until_succeeds("journalctl -o cat -u checkmate-capture.service | grep 'server started'")
    machine.succeed("curl -sSfN http://127.0.0.1:59232/health | grep \"OK\"")
    machine.succeed("curl -sSfN -H \"Authorization: Bearer APIPass\" http://127.0.0.1:59232/api/v1/metrics/host")

    machine.shutdown()
  '';

}
