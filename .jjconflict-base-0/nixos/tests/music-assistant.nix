{
  lib,
  ...
}:

{
  name = "music-assistant";
  meta.maintainers = with lib.maintainers; [ hexa ];

  nodes.machine = {
    services.music-assistant = {
      enable = true;
    };
  };

  testScript = ''
    machine.wait_for_unit("music-assistant.service")
    machine.wait_until_succeeds("curl --fail http://localhost:8095")
    machine.log(machine.succeed("systemd-analyze security music-assistant.service | grep -v ✓"))
  '';
}
