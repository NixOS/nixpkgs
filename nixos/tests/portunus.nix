{ lib, ... }:

{
  name = "portunus";
  meta.maintainers = with lib.maintainers; [ SuperSandro2000 ];

  nodes.machine = _: {
    services.portunus = {
      enable = true;
      ldap.suffix = "dc=example,dc=org";
    };
  };

  testScript = ''
    machine.wait_for_unit("portunus.service")
    machine.wait_for_open_port(8080)
    machine.wait_until_succeeds("curl --fail -vvv http://localhost:8080/")
  '';
}
