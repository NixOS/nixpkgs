{
  lib,
  ...
}:
{
  name = "udp514-enableService";
  meta.maintainers = with lib.maintainers; [ usovalx ];

  nodes.machine = {
    services.udp514-journal.enable = true;
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("udp514-journal.service");
  '';
}
