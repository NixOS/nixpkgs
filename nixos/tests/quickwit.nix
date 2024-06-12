import ./make-test-python.nix ({ lib, pkgs, ... }:

{
  name = "quickwit";
  meta.maintainers = [ pkgs.lib.maintainers.happysalada ];

  nodes = {
    quickwit = { config, pkgs, ... }: {
      services.quickwit.enable = true;
    };
  };

  testScript =
  ''
    quickwit.wait_for_unit("quickwit")
    quickwit.wait_for_open_port(7280)
    quickwit.wait_for_open_port(7281)

    quickwit.wait_until_succeeds(
      "journalctl -o cat -u quickwit.service | grep 'version: ${pkgs.quickwit.version}'"
    )

    quickwit.wait_until_succeeds(
      "journalctl -o cat -u quickwit.service | grep 'transitioned to ready state'"
    )

    quickwit.log(quickwit.succeed(
      "systemd-analyze security quickwit.service | grep -v '✓'"
    ))
  '';
})
