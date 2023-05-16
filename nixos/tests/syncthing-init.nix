import ./make-test-python.nix ({ lib, pkgs, ... }: let

  testId = "7CFNTQM-IMTJBHJ-3UWRDIU-ZGQJFR6-VCXZ3NB-XUH3KZO-N52ITXR-LAIYUAU";
<<<<<<< HEAD
  testName = "testDevice foo'bar";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

in {
  name = "syncthing-init";
  meta.maintainers = with pkgs.lib.maintainers; [ lassulus ];

  nodes.machine = {
    services.syncthing = {
      enable = true;
<<<<<<< HEAD
      settings.devices.testDevice = {
        id = testId;
      };
      settings.folders.testFolder = {
        path = "/tmp/test";
        devices = [ "testDevice" ];
      };
      settings.gui.user = "guiUser";
=======
      devices.testDevice = {
        id = testId;
      };
      folders.testFolder = {
        path = "/tmp/test";
        devices = [ "testDevice" ];
      };
      extraOptions.gui.user = "guiUser";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  testScript = ''
    machine.wait_for_unit("syncthing-init.service")
    config = machine.succeed("cat /var/lib/syncthing/.config/syncthing/config.xml")

    assert "testFolder" in config
    assert "${testId}" in config
    assert "guiUser" in config
  '';
})
