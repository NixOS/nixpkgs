{ pkgs, lib, ... }:
{
  name = "transfer-sh";

  meta = {
    maintainers = with lib.maintainers; [ ocfox ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.transfer-sh = {
        enable = true;
        settings.LISTENER = ":1234";
      };
    };

  testScript = ''
    machine.wait_for_unit("transfer-sh.service")
    machine.wait_for_open_port(1234)
    machine.succeed("curl --fail http://localhost:1234/")
  '';
}
