import ./make-test.nix {
  name = "nginx-pubhtml";

  machine = { pkgs, ... }: {
    services.nginx.enable = true;
    services.nginx.virtualHosts.localhost = {
      locations."~ ^/\\~([a-z0-9_]+)(/.*)?$".alias = "/home/$1/public_html$2";
    };
    users.users.foo.isNormalUser = true;
  };

  testScript = ''
    $machine->waitForUnit("nginx");
    $machine->waitForOpenPort(80);
    $machine->succeed(
      'chmod 0711 /home/foo',
      "su -c 'mkdir -p /home/foo/public_html' foo",
      "su -c 'echo bar > /home/foo/public_html/bar.txt' foo",
      'test "$(curl -fvvv http://localhost/~foo/bar.txt)" = bar',
    );
  '';
}
