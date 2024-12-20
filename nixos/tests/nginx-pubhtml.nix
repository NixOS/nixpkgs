import ./make-test-python.nix {
  name = "nginx-pubhtml";

  nodes.machine =
    { pkgs, ... }:
    {
      systemd.services.nginx.serviceConfig.ProtectHome = "read-only";
      services.nginx.enable = true;
      services.nginx.virtualHosts.localhost = {
        locations."~ ^/\\~([a-z0-9_]+)(/.*)?$".alias = "/home/$1/public_html$2";
      };
      users.users.foo.isNormalUser = true;
    };

  testScript = ''
    machine.wait_for_unit("nginx")
    machine.wait_for_open_port(80)
    machine.succeed("chmod 0711 /home/foo")
    machine.succeed("su -c 'mkdir -p /home/foo/public_html' foo")
    machine.succeed("su -c 'echo bar > /home/foo/public_html/bar.txt' foo")
    machine.succeed('test "$(curl -fvvv http://localhost/~foo/bar.txt)" = bar')
  '';
}
