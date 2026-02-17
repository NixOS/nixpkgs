{ lib, pkgs, ... }:
{
  name = "photoprism";
  meta.maintainers = with lib.maintainers; [ stunkymonkey ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.photoprism = {
        enable = true;
        port = 8080;
        originalsPath = "/media/photos/";
        passwordFile = "/etc/photoprism-password";
      };
      environment = {
        etc."photoprism-password".text = "secret";
        extraInit = ''
          mkdir -p /media/photos
        '';
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_open_port(8080)
    response = machine.succeed("curl -vvv -s -H 'Host: photoprism' http://127.0.0.1:8080/library/login")
    assert '<title>PhotoPrism</title>' in response, "Login page didn't load successfully"
  '';
}
