{ ... }:
let
  machineName = "machine";
  settingName = "prefix";
  settingValue = "/some/path";
in
{
  name = "npmrc";

  nodes."${machineName}".programs.npm = {
    enable = true;
    npmrc = ''
      ${settingName} = ${settingValue}
    '';
  };

  testScript = ''
    ${machineName}.start()

    assert ${machineName}.succeed("npm config get ${settingName}") == "${settingValue}\n"
  '';
}
