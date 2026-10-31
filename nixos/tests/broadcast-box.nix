{ pkgs, ... }:
{
  name = "broadcast-box";
  meta = { inherit (pkgs.broadcast-box.meta) maintainers; };

  nodes.machine = {
    services.broadcast-box = {
      enable = true;
      web = {
        host = "127.0.0.1";
        port = 8080;
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("broadcast-box.service")
    machine.wait_for_open_port(8080)
    machine.succeed("curl --fail http://localhost:8080/")
  '';
}
