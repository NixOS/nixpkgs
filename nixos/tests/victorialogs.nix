{ lib, ... }:
{
  name = "victorialogs";
  meta.maintainers = with lib.maintainers; [ marie ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.victorialogs.enable = true;

      services.journald.upload = {
        enable = true;
        settings = {
          Upload.URL = "http://localhost:9428/insert/journald";
        };
      };
      environment.systemPackages = [ pkgs.curl ];
    };

  testScript = ''
    machine.wait_for_unit("victorialogs.service")

    machine.succeed("echo 'meow' | systemd-cat -p info")
    machine.wait_until_succeeds("curl --fail http://localhost:9428/select/logsql/query -d 'query=\"meow\"' | grep meow")
  '';
}
