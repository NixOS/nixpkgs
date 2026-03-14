{
  lib,
  ...
}:
{
  name = "postfix-tlspol";

  meta.maintainers = with lib.maintainers; [ hexa ];

  nodes.machine = {
    services.postfix.enable = true;
    services.postfix-tlspol.enable = true;

    services.dnsmasq = {
      enable = true;
      settings.selfmx = true;
    };
  };

  testScript = ''
    import json

    machine.wait_for_unit("postfix-tlspol.service")
    machine.succeed("getent group postfix-tlspol | grep :postfix")

    with subtest("Interact with the service"):
      machine.succeed("postfix-tlspol -purge")

      response = json.loads((machine.succeed("postfix-tlspol -query localhost")))
      machine.log(json.dumps(response, indent=2))

      assert response["dane"]["policy"] == "", f"Unexpected DANE policy for localhost: {response["dane"]["policy"]}"
      assert response["mta-sts"]["policy"] == "", f"Unexpected MTA-STS policy for localhost: {response["mta-sts"]["policy"]}"

    machine.log(machine.execute("systemd-analyze security postfix-tlspol.service | grep -v ✓")[1])
  '';

}
