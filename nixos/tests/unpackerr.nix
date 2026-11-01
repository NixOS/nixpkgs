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
        folder.downloads.path = "/srv/unpackerr";
      };
    };
  };

  testScript =
    let
      archive = hostPkgs.runCommand "unpackerr-test.zip" { nativeBuildInputs = [ hostPkgs.zip ]; } ''
        echo unpackerr-test > file.txt
        zip -b "$TMPDIR" "$out" file.txt
      '';
    in
    ''
      with subtest("Unpackerr watches the configured folder"):
        machine.wait_for_unit("unpackerr.service")
        machine.wait_until_succeeds("journalctl --unit unpackerr.service --invocation 0 --grep 'Watching \\(fsnotify\\): /srv/unpackerr$'")

      with subtest("Unpackerr extracts an archive added to the folder"):
        machine.succeed("cp ${archive} /srv/unpackerr/test.zip")
        machine.wait_for_file("/srv/unpackerr/test/file.txt")
        assert machine.succeed("cat /srv/unpackerr/test/file.txt") == "unpackerr-test\n"
    '';
}
