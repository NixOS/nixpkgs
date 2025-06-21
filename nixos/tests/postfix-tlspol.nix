{
  lib,
  ...
}:
{
  name = "postfix-tlspol";

  meta.maintainers = with lib.maintainers; [ hexa ];

  nodes.machine = {
    services.postfix-tlspol.enable = true;
  };

  enableOCR = true;

  testScript = ''
    import json

    machine.wait_for_unit("postfix-tlspol.service")

    with subtest("Interact with the service"):
      machine.succeed("postfix-tlspol -purge")

      response = json.loads((machine.succeed("postfix-tlspol -query localhost")))
      machine.log(json.dumps(response, indent=2))

  '';

}
