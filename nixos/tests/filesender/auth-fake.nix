{
  pkgs,
  lib,
  ...
}:
{
  name = "FileSender";
  meta.teams = with lib.teams; [ ngi ];

  nodes.filesender =
    { pkgs, lib, ... }:
    {
      services.filesender = {
        enable = true;
        localDomain = "localhost";
        auth.backend = "fake";

        settings = {
          force_ssl = false;
          admin = "user";
          admin_email = "admin@localhost";
          email_reply_to = "noreply@localhost";
        };
      };

      networking.firewall.allowedTCPPorts = [
        80
      ];
    };

  testScript =
    # python
    ''
      start_all()

      filesender.wait_for_unit("phpfpm-filesender.service")
      filesender.wait_for_open_port(80)

      filesender.succeed("curl -sS -f http://localhost/ -o /tmp/filesender.html")
      filesender.succeed("grep -q 'FileSender' /tmp/filesender.html")

      filesender.succeed(
        "sudo -u postgres psql -d filesender -tAc 'select count(*) from transfers'"
      )
    '';

  interactive.sshBackdoor.enable = true;
}
