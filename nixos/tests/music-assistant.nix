{
  pkgs,
  ...
}:

{
  name = "music-assistant";
  meta = { inherit (pkgs.music-assistant.meta) maintainers; };

  containers.machine = {
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
