{ lib, pkgs, ... }:
{
  name = "facter";
  meta = with lib.maintainers; {
    maintainers = [ mic92 ];
  };

  nodes.machine = {
    hardware.facter.reportPath = ./facter.json;
    environment.systemPackages = [ pkgs.nixos-facter ];
  };

  testScript = ''
    from pprint import pprint

    machine.wait_for_unit("multi-user.target")

    with subtest("Run nixos-facter and verify it produces valid JSON"):
      import json
      # Run nixos-facter and check it produces valid output
      output = machine.succeed("nixos-facter")
      # Parse JSON to verify it's valid
      report = json.loads(output)
      pprint(report)
      assert "version" in report, "Expected version field in nixos-facter output"
      assert "system" in report, "Expected system field in nixos-facter output"
      assert report["version"] == 1, f"Expected version 1, got {report['version']}"
  '';
}
