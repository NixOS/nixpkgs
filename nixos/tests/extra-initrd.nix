{ runTest, lib }:
let
  common =
    { config, pkgs, ... }:
    {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;
      system.boot.extraInitrd.paths = [
        extraInitrdPath
      ];

      boot.loader.timeout = 2;

      boot.initrd.systemd.mounts = [
        {
          what = "/canary.txt";
          where = "/sysroot/run/canary.txt";
          type = "none";
          options = "bind";
          unitConfig = {
            DefaultDependencies = false;
          };
          requiredBy = [ "initrd-fs.target" ];
          before = [ "initrd-fs.target" ];
        }
      ];
    };

  extraInitrdPath = "custom.cpio";
  canaryCpio =
    pkgs:
    pkgs.runCommand "canary.cpio"
      {
        nativeBuildInputs = [ pkgs.cpio ];
      }
      ''
        echo canary > canary.txt
        find . -print0 | cpio --null -o --format=newc > $out
      '';

  testScript =
    # python
    ''
      machine.wait_for_unit("multi-user.target")

      # Check that the extra cpio archive is on the ESP
      machine.succeed("test -e /boot/custom.cpio")

      # Check that the initrd that we booted with contained the file from
      # the extra initrd and our initrd mount unit bound it into sysroot
      assert machine.succeed("cat /run/canary.txt").strip() == "canary"
    '';
  systemdBootTest =
    uki:
    runTest (
      { pkgs, ... }: {
        name = "systemd-boot-extra-initrd" + lib.optionalString uki "-uki";

        nodes.machine = { config, ... }: {
          imports = [ common ];

          boot.loader.systemd-boot = {
            enable = true;
            uki.enable = uki;
            ${if uki then "extraPrepareCommands" else "extraInstallCommands"} = ''
              cp ${canaryCpio pkgs} ${config.boot.loader.efi.efiSysMountPoint}/${extraInitrdPath}
            '';
          };
        };

        testScript =
          lib.optionalString uki "machine.start(allow_reboot=True)\n"
          + testScript
          + lib.optionalString uki ''
            machine.succeed("bootctl status | grep -F systemd-stub")
            # A conflicting installer-CWD archive must not override the ESP file.
            machine.succeed("printf incorrect > /root/custom.cpio")
            machine.succeed("cd /root; /run/current-system/bin/switch-to-configuration boot")
            machine.reboot()
            machine.wait_for_unit("multi-user.target")
            assert machine.succeed("cat /run/canary.txt").strip() == "canary"
            machine.succeed("bootctl status | grep -F systemd-stub")
          '';
      }
    );
in
{
  systemd-boot = systemdBootTest false;
  systemd-boot-uki = systemdBootTest true;

  limine = runTest {
    name = "limine-extra-initrd";

    nodes.machine = { pkgs, config, ... }: {
      imports = [ common ];

      boot.loader.limine = {
        enable = true;
        efiSupport = true;
        enableEditor = true;
        extraInstallCommands = ''
          cp ${canaryCpio pkgs} ${config.boot.loader.efi.efiSysMountPoint}/${extraInitrdPath}
        '';
      };

    };

    inherit testScript;
  };
}
