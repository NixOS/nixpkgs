# The following was modified from ./earlyoom.nix
{ lib, pkgs, ... }:
{
  name = "nohang";
  meta = {
    maintainers = with lib.maintainers; [
      Dev380
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      # Limit VM resource usage.
      virtualisation.memorySize = 1024;

      services.nohang.enable = true;
      # disable other oom killers just in case
      systemd.oomd.enable = false;

      systemd.services.testbloat = {
        description = "Create a lot of memory pressure";
        serviceConfig = {
          ExecStart = "${lib.getExe' pkgs.coreutils "tail"} /dev/zero";
        };
      };
    };

  # SIGTERM may be given so tail /dev/zero may or may not succeed
  # The output will have have something like "Sending SIGTERM to /nix/store/87fc"
  # with the truncated path so we'll check for that in the test
  testScript = ''
    machine.wait_for_unit("nohang.service")

    with subtest("nohang should kill the bad service"):
        machine.execute("systemctl start --wait testbloat.service")
        signal_type = None
        match machine.get_unit_info("testbloat.service")["Result"]:
          case "signal":
            signal_type = "SIGKILL"
          case "success":
            signal_type = "SIGTERM"
        output = machine.succeed('journalctl -u nohang.service -b0')

        if not f'[ OK ] Sending {signal_type}' in output:
          raise Exception(f"'[ OK ] Sending {signal_type}' not in output")
        if not 'The victim' in output:
          raise Exception("'The victim' not in output")
        if not 'Memory status after implementing a corrective action:' in output:
          raise Exception("'Memory status after implementing a corrective action:' not in output")
        if not 'FINISHING implement_corrective_action()' in output:
          raise Exception("'FINISHING implement_corrective_action()' not in output")
        if not f"{signal_type} to {'${pkgs.coreutils}'[:len('/nix/store/1234')]}: 1" in output:
          raise Exception(f"'{signal_type} to {'${pkgs.coreutils}'[:len('/nix/store/1234')]}: 1' not in output")
  '';
}
