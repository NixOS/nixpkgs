{
  pkgs,
  lib,
  ...
}:
{
  name = "FileSender";
  meta.maintainers = lib.teams.ngi.maintainers;

  nodes.filesender =
    { pkgs, lib, ... }:
    {
      services.filesender = {
        enable = true;
        localDomain = "filesender";
        settings = {
          auth_sp_type = "fake";
          auth_sp_fake_authenticated = true;
          auth_sp_fake_uid = "user";
          auth_sp_fake_email = "user@example.org";
          auth_sp_fake_name = "User";

          storage_filesystem_path = "/var/lib/filesender/files";
          site_url = "http://filesender";
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
