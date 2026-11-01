{ hostPkgs, lib, ... }: {
  name = "unpackerr";
  meta.maintainers = with lib.maintainers; [
    connor-grady
    Wekuz
  ];

  nodes.machine = {
    systemd.tmpfiles.settings.unpackerr."/srv/unpackerr".d.user = "unpackerr";

    services.unpackerr = {
      enable = true;
      settings = {
        start_delay = "15s";
        file_mode = "0600";
        folder.downloads.path = "/srv/unpackerr";
        webserver = {
          ui_password = "noauth";
          upstreams = [ "127.0.0.1/32" ];
        };
      };
    };

    specialisation.customDirs.configuration.services.unpackerr = {
      dataDir = "/srv/unpackerr-data";
      logDir = "/srv/unpackerr-logs";
    };
  };

  testScript =
    { nodes, ... }:
    let
      inherit (nodes.machine.system.build) toplevel;
      archive = hostPkgs.runCommand "unpackerr-test.zip" { nativeBuildInputs = [ hostPkgs.zip ]; } ''
        echo unpackerr-test > file.txt
        zip -b "$TMPDIR" "$out" file.txt
      '';
    in
    ''
      import json

      def wait_for_unpackerr():
        machine.wait_for_unit("unpackerr.service")
        machine.wait_for_open_port(5656)
        machine.wait_until_succeeds("journalctl --unit unpackerr.service --invocation 0 --grep 'Watching \\(fsnotify\\): /srv/unpackerr$'")

      def api(path, curl_args=""):
        return json.loads(machine.succeed(f"curl --fail --silent {curl_args} http://127.0.0.1:5656/api/{path}"))

      with subtest("Unpackerr watches the configured folder"):
        wait_for_unpackerr()

      with subtest("Unpackerr extracts an archive added to the folder"):
        machine.succeed("cp ${archive} /srv/unpackerr/test.zip")
        machine.wait_for_file("/srv/unpackerr/test/file.txt")
        assert machine.succeed("cat /srv/unpackerr/test/file.txt") == "unpackerr-test\n"

      with subtest("Extracted files use the configured file mode"):
        mode = machine.succeed("stat --format %a /srv/unpackerr/test/file.txt").strip()
        assert mode == "600", f"expected mode 600, got {mode}"

      with subtest("Settings saved through the web UI survive a restart"):
        general = api("config/general") | {"interval": "5m", "startDelay": "45s"}
        api("config/general", f"--request PUT --json '{json.dumps(general)}'")
        machine.succeed("systemctl restart unpackerr.service")
        wait_for_unpackerr()
        assert api("config/general/live")["interval"] == "5m", "the web UI setting was lost"

      with subtest("Settings from Nix override settings saved through the web UI"):
        assert api("config/general/live")["startDelay"] == "15s", "the web UI setting overrode Nix"

      with subtest("Unpackerr's state and logs move to custom directories"):
        machine.succeed("systemctl stop unpackerr.service")
        machine.succeed("mv /var/lib/unpackerr /srv/unpackerr-data")
        machine.succeed("${toplevel}/specialisation/customDirs/bin/switch-to-configuration test")
        machine.succeed("systemctl start unpackerr.service")
        wait_for_unpackerr()
        machine.succeed("findmnt --noheadings --output SOURCE --mountpoint /var/lib/unpackerr | grep -F '[/srv/unpackerr-data]'")
        machine.succeed("findmnt --noheadings --output SOURCE --mountpoint /var/log/unpackerr | grep -F '[/srv/unpackerr-logs]'")
        assert api("config/general/live")["interval"] == "5m", "Unpackerr's state did not carry over"
        machine.succeed("test -e /srv/unpackerr-logs/unpackerr.log -a -e /srv/unpackerr-logs/http.log")

      with subtest("Reloading Unpackerr reopens its log files"):
        pid = machine.succeed("systemctl show --property MainPID --value unpackerr.service")
        machine.succeed("mv /var/log/unpackerr/unpackerr.log /var/log/unpackerr/unpackerr.log.1")
        machine.succeed("systemctl reload unpackerr.service")
        machine.wait_for_file("/var/log/unpackerr/unpackerr.log")
        assert machine.succeed("systemctl show --property MainPID --value unpackerr.service") == pid, "reload restarted Unpackerr"
    '';
}
