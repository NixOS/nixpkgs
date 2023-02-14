import ./make-test-python.nix ({ pkgs, ... }: {
  name = "asterisk";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ yorickvp ];
  };

  nodes.machine =
    { ... }:
    {
      services.asterisk = {
        enable = true;
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("asterisk.service")

    with machine.nested("Waiting for asterisk to work"):
        machine.wait_until_succeeds("asterisk -r -x \"show uptime\"", timeout=10)
  '';
})
