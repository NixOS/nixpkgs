{ ... }:
{
  name = "bookorbit";

  containers.machine = {
    services.bookorbit = {
      enable = true;
      environment = {
        JWT_SECRET = "abcdefghijklmnop";
        SETUP_BOOTSTRAP_TOKEN = "abcdefgh";
      };
    };
  };

  testScript = ''
    machine.wait_for_unit('bookorbit.service')

    machine.wait_for_open_port(3000)
    machine.succeed('curl --fail http://localhost:3000 | grep BookOrbit')
  '';
}
