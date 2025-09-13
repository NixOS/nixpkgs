{ lib, ... }:

{
  name = "ksm";
  meta = with lib.maintainers; {
    maintainers = [ rnhmjoj ];
  };

  nodes.machine =
    { ... }:
    {
      imports = [ ../modules/profiles/minimal.nix ];

      hardware.ksm.enable = true;
      hardware.ksm.sleep = 300;
    };

  testScript = ''
    machine.start()
    machine.wait_until_succeeds("test $(</sys/kernel/mm/ksm/run) -eq 1")
    machine.wait_until_succeeds("test $(</sys/kernel/mm/ksm/sleep_millisecs) -eq 300")
  '';
}
