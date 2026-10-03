{
  pkgs ? import <nixpkgs> { },
}:

pkgs.nixosTest {
  name = "plakar";

  nodes.machine =
    { ... }:
    {
      imports = [ ./plakar.nix ];

      services.plakar = {
        stores.main.location = "/var/lib/plakar/store";
        defaultStore = "main";

        server = {
          enable = true;
          repository = "@main";
          initialize = true;
        };

        backups.test = {
          repository = "http://127.0.0.1:9876";
          paths = [ "/etc/machine-id" ];
          tags = [ "test" ];
          timerConfig = null;
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("plakar-server.service")
    machine.wait_for_open_port(9876)
    machine.succeed("test -e /var/lib/plakar/store/CONFIG")
    machine.succeed("systemctl start plakar-backups-test.service")
    machine.succeed("plakar-test ls | grep -q test")
  '';
}
