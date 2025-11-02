{
  name = "syncthing-multi";

  nodes.machine = {
    users.users.test.isNormalUser = true;

    services.syncthing-multi = {
      enable = true;
      instances = {
        syncthing.settings.gui-address = "localhost:8000";
        test.settings.gui-address = "localhost:8010";
      };
    };
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("syncthing-syncthing.service")
    machine.wait_for_open_port(8000)
    machine.succeed("curl --fail http://localhost:8000/")

    machine.wait_for_unit("syncthing-test.service")
    machine.wait_for_open_port(8010)
    machine.succeed("curl --fail http://localhost:8010/")

    machine.shutdown()
  '';
}
