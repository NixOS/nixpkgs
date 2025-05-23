{ lib, ... }:

let
  port = 8088;
in

{
  name = "omada";
  meta.maintainers = with lib.maintainers; [ pathob ];

  nodes.machine =
    {
      ...
    }:

    {
      services.omada = {
        enable = true;
      };
    };

  testScript = ''
    def omada_is_up(_) -> bool:
        status, _ = machine.execute("curl --fail http://localhost:${toString port}")
        return status == 0

    machine.start()
    machine.wait_for_unit("omada.service")
    machine.wait_for_open_port(${toString port})

    with machine.nested("Waiting for UI to work"):
        retry(omada_is_up)
  '';
}
