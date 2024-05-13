{ lib, ... }:

{
  name = "pretalx";
  meta.maintainers = lib.teams.c3d2.members;

  nodes = {
    pretalx = {
      networking.extraHosts = ''
        127.0.0.1 talks.local
      '';

      services.pretalx = {
        enable = true;
        nginx.domain = "talks.local";
        settings = {
          site.url = "http://talks.local";
        };
      };
    };
  };

  testScript = ''
    start_all()

    pretalx.wait_for_unit("pretalx-web.service")
    pretalx.wait_for_unit("pretalx-worker.service")

    pretalx.wait_until_succeeds("curl -q --fail http://talks.local/orga/")

    pretalx.succeed("pretalx-manage --help")

    pretalx.log(pretalx.succeed("systemd-analyze security pretalx-web.service"))
  '';
}
