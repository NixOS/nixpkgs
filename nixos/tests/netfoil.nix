{ lib, ... }:
{
  name = "netfoil";
  meta.maintainers = with lib.maintainers; [
    marcusramberg
    sgo
  ];

  nodes = {
    one =
      { config, ... }:
      {
        services.netfoil = {
          enable = true;
          listen.port = 6353;
        };
      };
  };
  interactive.sshBackdoor.enable = true;

  testScript = ''
    start_all()

    with subtest("ensure netfoil starts and listens on 6353"):
        one.wait_for_unit("netfoil.service")
        # one.wait_for_open_port(5353)
  '';
}
