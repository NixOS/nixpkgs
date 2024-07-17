import ./make-test-python.nix ({ lib, ... }: {
  name = "filebrowser";
  meta.maintainers = [ lib.maintainers.sqlazer ];

  nodes.machine = { pkgs, ... }: { services.filebrowser.enable = true; };

  testScript = ''
    machine.wait_for_unit("filebrowser.service")
    machine.wait_for_open_port(5983)
    machine.succeed("curl --fail http://localhost:5983/")
  '';
})
