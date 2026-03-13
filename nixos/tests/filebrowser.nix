{
  name = "filebrowser";

  nodes.machine = {
    services.filebrowser = {
      enable = true;
      settings = {
        address = "localhost";
        port = 8080;
        database = "/var/lib/filebrowser/filebrowser.db";
      };
    };
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("filebrowser.service")
    machine.wait_for_open_port(8080)

    machine.succeed("curl --fail http://localhost:8080/")

    machine.succeed("stat /var/lib/filebrowser/filebrowser.db")

    machine.shutdown()
  '';
}
