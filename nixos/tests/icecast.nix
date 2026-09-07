{
  pkgs,
  ...
}:

{
  name = "icecast";
  meta = {
    inherit (pkgs.icecast.meta) maintainers;
  };

  nodes.machine = {
    services.icecast = {
      enable = true;
      hostname = "nixos.test";
      admin.password = "test";
    };
  };

  testScript = ''
    machine.wait_for_unit("icecast.service")
    machine.wait_for_open_port(8000)
    machine.succeed("curl -fail http://localhost:8000 | grep -q 'DO NOT ATTEMPT TO PARSE ICECAST HTML OUTPUT'")
  '';
}
