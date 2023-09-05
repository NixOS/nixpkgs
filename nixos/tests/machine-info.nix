let
  machineInfo = {
    prettyHostname = "コンピュータ";
    iconName = "computer-vm";
    chassis = "vm";
    deployment = "integration";
    location = "Nixpkgs";
    hardwareVendor = "NixOS";
    hardwareModel = "tests";
  };
in
{ lib, ... }: {
  name = "machine-info";
  meta.maintainers = [ lib.maintainers.tie ];

  nodes.machine.environment = { inherit machineInfo; };

  testScript = ''
    import json

    start_all()

    machineInfo = json.loads(machine.succeed("hostnamectl --json=short"))
    assert machineInfo["PrettyHostname"] == "${machineInfo.prettyHostname}"
    assert machineInfo["IconName"] == "${machineInfo.iconName}"
    assert machineInfo["Chassis"] == "${machineInfo.chassis}"
    assert machineInfo["Deployment"] == "${machineInfo.deployment}"
    assert machineInfo["Location"] == "${machineInfo.location}"
    assert machineInfo["HardwareVendor"] == "${machineInfo.hardwareVendor}"
    assert machineInfo["HardwareModel"] == "${machineInfo.hardwareModel}"
  '';
}
