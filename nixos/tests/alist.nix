{ lib, ... }:
{
  name = "alist";

  meta.maintainers = with lib.maintainers; [ moraxyc ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.curl ];
      services.alist = {
        enable = true;
        settings.jwt_secret = {
          _secret = pkgs.writeText "password" "supersecret";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("alist.service")

    machine.wait_for_open_port(5244)

    machine.succeed("curl --fail --max-time 10 http://localhost:5244")
  '';
}
