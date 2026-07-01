{ ... }:
{
  name = "bookorbit";

  nodes.machine = {
    services.bookorbit = {
      enable = true;
      bookPath = "/var/empty";
      environment = {
        JWT_SECRET = "abcdefghijklmnop";
        SETUP_BOOTSTRAP_TOKEN = "abcdefgh";
        LOG_LEVEL = "debug";
      };
    };
  };

  enableDebugHook = true;
  sshBackdoor.enable = true;

  testScript =
    { nodes, ... }:
    let
      port = toString nodes.machine.services.bookorbit.environment.PORT;
    in
    ''
      machine.wait_for_unit('bookorbit.service')

      machine.wait_for_open_port(${port})
      machine.succeed('curl --fail http://localhost:${port}')
    '';
}
