{
  pkgs,
  ...
}:

{
  name = "firefox-syncserver";
  nodes.machine = {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    services.firefox-syncserver = {
      enable = true;
      secrets = pkgs.writeText "secret" "this-is-a-test";
      singleNode = {
        enable = true;
        hostname = "firefox-syncserver.local";
        capacity = 1;
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("firefox-syncserver.service")
    machine.wait_for_open_port(5000)

    machine.wait_until_succeeds("curl --fail http://127.0.0.1:5000")

  '';
}
