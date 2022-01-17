import ./make-test-python.nix ({ pkgs, lib, ...} :

{
  name = "botamusique";
  meta.maintainers = with lib.maintainers; [ hexa ];

  nodes = {
    machine = { config, ... }: {
      services.mumble-server = {
        enable = true;
        registerName = "NixOS tests";
      };

      services.botamusique = {
        enable = true;
        settings = {
          server = {
            channel = "NixOS tests";
          };
          bot = {
            version = false;
            auto_check_update = false;
          };
        };
      };
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("mumble-server.service")
    machine.wait_for_unit("botamusique.service")

    machine.sleep(10)

    machine.wait_until_succeeds(
        "journalctl -u mumble-server.service -e | grep -q '<1:botamusique(-1)> Authenticated'"
    )

    with subtest("Check systemd hardening"):
        output = machine.execute("systemctl show botamusique.service")[1]
        machine.log(output)
        output = machine.execute("systemd-analyze security botamusique.service")[1]
        machine.log(output)
  '';
})
