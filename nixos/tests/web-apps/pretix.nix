{
  lib,
  pkgs,
  ...
}:

{
  name = "pretix";
  meta.maintainers = with lib.maintainers; [ hexa ];

  nodes = {
    pretix = {
      networking.extraHosts = ''
        127.0.0.1 tickets.local
      '';

      services.pretix = {
        enable = true;
        nginx.domain = "tickets.local";
        plugins = with pkgs.pretix.plugins; [
          passbook
          pages
          zugferd
        ];
        settings = {
          pretix = {
            instance_name = "NixOS Test";
            url = "http://tickets.local";
          };
          mail.from = "hello@tickets.local";
        };
      };
    };
  };

  testScript = ''
    start_all()

    pretix.wait_for_unit("pretix-web.service")
    pretix.wait_for_unit("pretix-worker.service")

    pretix.wait_until_succeeds("curl -q --fail http://tickets.local")

    pretix.succeed("pretix-manage --help")

    pretix.log(pretix.succeed("systemd-analyze security pretix-web.service"))
  '';
}
