{ lib, pkgs, ... }:

let
  app-key = "base64:VGVzdFRlc3RUZXN0VGVzdFRlc3RUZXN0VGVzdFRlc3Q=";
in
{
  name = "speedtest-tracker";
  meta = {
    maintainers = pkgs.speedtest-tracker.meta.maintainers;
    platforms = lib.platforms.linux;
  };

  nodes.sqlite = {
    environment.etc."speedtest-tracker-appkey".text = app-key;
    services.speedtest-tracker = {
      enable = true;
      enableNginx = true;
      settings = {
        APP_KEY_FILE = "/etc/speedtest-tracker-appkey";
      };
    };
  };

  testScript = ''
    sqlite.wait_for_unit("phpfpm-speedtest-tracker.service")
    sqlite.wait_for_unit("nginx.service")
    sqlite.wait_for_unit("speedtest-tracker-queue-worker.service")

    sqlite.succeed("curl -Ls -o /dev/null -w '%{http_code}' http://localhost/admin/login | grep '200'")
    sqlite.succeed("curl -Ls http://localhost/admin/login | grep -i 'login'")
    sqlite.succeed("systemctl start speedtest-tracker-scheduler.service")
  '';
}
