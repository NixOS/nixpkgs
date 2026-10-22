{ lib, ... }:
let

  testId = "7CFNTQM-IMTJBHJ-3UWRDIU-ZGQJFR6-VCXZ3NB-XUH3KZO-N52ITXR-LAIYUAU";

in
{
  name = "syncthing-init";
  meta.maintainers = with lib.maintainers; [
    lassulus
    me-and
  ];

  containers.machine = {
    services.syncthing = {
      enable = true;
      settings.devices.testDevice = {
        id = testId;
        addresses = [
          "tcp://192.0.2.42:12345"
          "tcp://[2001:db8::23:42]:12345"
        ];
      };
      settings.folders.testFolder = {
        path = "/tmp/test";
        devices = [ "testDevice" ];
      };
      settings.gui.user = "guiUser";
    };
  };

  testScript = ''
    machine.wait_for_unit("syncthing-init.service")
    config = machine.succeed("cat /var/lib/syncthing/.config/syncthing/config.xml")

    assert "testFolder" in config
    assert "${testId}" in config
    assert "guiUser" in config
    assert "tcp://192.0.2.42:12345" in config
    assert "tcp://[2001:db8::23:42]:12345" in config
  '';
}
