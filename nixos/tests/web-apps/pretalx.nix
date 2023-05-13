{ lib, ... }:
{
  name = "pretalx";
  meta.maintainers = with lib.maintainers; [
    hexa
  ];

  nodes = {
    pretalx = { ... }: {
      networking.extraHosts = ''
        127.0.0.1 talks.local
      '';

      services.nginx.enable = true;
      services.postgresql.enable = true;

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
  '';
}
