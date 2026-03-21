_: {
  name = "sure";

  nodes.machine = _: {
    services.sure = {
      enable = true;
      localDomain = "localhost";
    };
  };

  testScript =
    { nodes, ... }:
    let
      webPort = toString nodes.machine.services.sure.webPort;
      url = "${nodes.machine.services.sure.localDomain}:${webPort}";
    in

    ''
      machine.wait_for_unit("sure.target")
      machine.wait_for_open_port(${webPort}) # Web
      machine.succeed("curl -s --fail ${url}/up")
    '';
}
