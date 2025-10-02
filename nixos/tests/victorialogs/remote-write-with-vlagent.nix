{ lib, pkgs, ... }:
let

  username = "vltest";
  password = "rUceu1W41U"; # random string
  passwordFile = pkgs.writeText "password-file" password;
in
{
  name = "victorialogs-remote-write-with-vlagent";
  meta.maintainers = [ lib.maintainers.shawn8901 ];

  nodes.server =
    { pkgs, ... }:
    {
      networking.firewall.allowedTCPPorts = [ 9428 ];
      services.victorialogs = {
        enable = true;
        basicAuthUsername = username;
        basicAuthPasswordFile = toString passwordFile;
      };
    };

  nodes.client =
    { pkgs, ... }:
    {
      services.vlagent = {
        enable = true;
        remoteWrite = {
          url = "http://server:9428/internal/insert";
          basicAuthUsername = username;
          basicAuthPasswordFile = toString passwordFile;
        };
      };

      services.journald.upload = {
        enable = true;
        settings = {
          Upload.URL = "http://localhost:9429/insert/journald";
        };
      };
      environment.systemPackages = [ pkgs.curl ];

    };

  testScript = ''
    server.wait_for_unit("victorialogs.service")
    server.wait_for_open_port(9428)

    client.wait_for_unit("vlagent")
    client.wait_for_open_port(9429)

    client.wait_for_unit("systemd-journal-upload")

    client.succeed("echo 'meow' | systemd-cat -p info")

    server.wait_until_succeeds("curl -u ${username}:${password} --fail http://localhost:9428/select/logsql/query -d 'query=\"meow\"' | grep meow")
  '';
}
