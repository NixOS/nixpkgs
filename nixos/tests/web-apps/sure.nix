{ lib, ... }:
{
  name = "sure";
  meta.maintainers = with lib.maintainers; [
    _74k1
    pjrm
  ];

  containers.machine = _: {
    services.sure = {
      enable = true;
      localDomain = "localhost";
    };
  };

  testScript =
    { containers, ... }:
    let
      webPort = toString containers.machine.services.sure.webPort;
      url = "${containers.machine.services.sure.localDomain}:${webPort}";
    in

    ''
      machine.wait_for_unit("sure.target")
      machine.wait_for_open_port(${webPort}) # Web
      machine.succeed("curl -s --fail ${url}/up")
    '';
}
