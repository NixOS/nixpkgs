{ lib, ... }:
{
  name = "snips-sh";

  nodes.machine = {
    services.snips-sh = {
      enable = true;
      settings = {
        SNIPS_HTTP_INTERNAL = "http://0.0.0.0:8080";
        SNIPS_SSH_INTERNAL = "ssh://0.0.0.0:2222";
      };
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("snips-sh.service")
    machine.wait_for_open_port(8080)
    machine.succeed("curl --fail http://localhost:8080")
  '';

  meta.maintainers = with lib.maintainers; [
    isabelroses
    NotAShelf
  ];
}
