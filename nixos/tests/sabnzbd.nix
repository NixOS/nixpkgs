{ lib, ... }:
{
  name = "sabnzbd";
  meta.maintainers = with lib.maintainers; [ jojosch ];

  node.pkgsReadOnly = false;

  nodes.machine =
    { lib, ... }:
    {
      services.sabnzbd = {
        enable = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("sabnzbd.service")
    machine.wait_until_succeeds(
        "curl --fail -L http://localhost:8080/"
    )
    _, out = machine.execute("grep SABCTools /var/lib/sabnzbd/logs/sabnzbd.log")
    machine.log(out)
    machine.fail("grep 'SABCTools disabled: no correct version found!' /var/lib/sabnzbd/logs/sabnzbd.log")
  '';
}
