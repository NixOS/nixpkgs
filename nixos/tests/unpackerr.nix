{ lib, ... }:

{
  name = "unpackerr";
  meta.maintainers = with lib.maintainers; [ Wekuz ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ zip ];

      systemd.tmpfiles.settings."10-unpackerr"."/srv/unpackerr".d = {
        mode = "0775";
        user = "unpackerr";
        group = "users";
      };

      services.unpackerr = {
        enable = true;
        group = "users";
        settings = {
          start_delay = "15s";
          folder = [
            {
              path = "/srv/unpackerr";
            }
          ];
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("unpackerr.service")
    machine.wait_until_succeeds("journalctl -u unpackerr.service --grep '\\[Folder\\] Watching \\(fsnotify\\)'", timeout=60)
    machine.execute("echo unpackerr-test > /tmp/file.txt && cd /tmp && zip /srv/unpackerr/test.zip ./file.txt && rm ./file.txt")
    machine.wait_until_succeeds("[[ -d /srv/unpackerr/test ]]", timeout=120)
    machine.succeed("""[[ 'unpackerr-test' == "$(< /srv/unpackerr/test/file.txt)" ]]""")
  '';
}
