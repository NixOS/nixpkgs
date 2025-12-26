{ lib, pkgs, ... }:
let
  confPath = "/etc/waagent.conf";
in
{
  name = "waagent";

  meta = {
    maintainers = with lib.maintainers; [ codgician ];
  };

  nodes.machine = {
    services.waagent = {
      enable = true;
      settings = {
        Provisioning = {
          Enable = false;
          Agent = "waagent";
          DeleteRootPassword = false;
          RegenerateSshHostKeyPair = false;
          SshHostKeyPairType = "ed25519";
          MonitorHostName = false;
        };
        ResourceDisk = {
          Format = false;
          MountOptions = [
            "compress=lzo"
            "mode=0600"
          ];
        };
        OS.RootDeviceScsiTimeout = 300;
        HttpProxy = {
          Host = null;
          Port = null;
        };
        CGroups = {
          EnforceLimits = false;
          Excluded = [ ];
        };
      };
    };
  };

  testScript = ''
    # Defined values should be reflected in waagent.conf
    machine.succeed("grep -q '^Provisioning.Enable=n$' '${confPath}'")
    machine.succeed("grep -q '^Provisioning.Agent=waagent$' '${confPath}'")
    machine.succeed("grep -q '^Provisioning.DeleteRootPassword=n$' '${confPath}'")
    machine.succeed("grep -q '^Provisioning.RegenerateSshHostKeyPair=n$' '${confPath}'")
    machine.succeed("grep -q '^Provisioning.SshHostKeyPairType=ed25519$' '${confPath}'")
    machine.succeed("grep -q '^Provisioning.MonitorHostName=n$' '${confPath}'")
    machine.succeed("grep -q '^ResourceDisk.Format=n$' '${confPath}'")
    machine.succeed("grep -q '^ResourceDisk.MountOptions=compress=lzo,mode=0600$' '${confPath}'")
    machine.succeed("grep -q '^OS.RootDeviceScsiTimeout=300$' '${confPath}'")

    # Undocumented options should also be supported
    machine.succeed("grep -q '^CGroups.EnforceLimits=n$' '${confPath}'")

    # Null values should be skipped and not exist in waagent.conf
    machine.fail("grep -q '^HttpProxy.Host=' '${confPath}'")
    machine.fail("grep -q '^HttpProxy.Port=' '${confPath}'")

    # Empty lists should be skipped and not exist in waagent.conf
    machine.fail("grep -q '^CGroups.Excluded=' '${confPath}'")

    # Test service start
    # Skip testing actual functionality due to lacking Azure infrasturcture
    machine.wait_for_unit("waagent.service")
  '';
}
