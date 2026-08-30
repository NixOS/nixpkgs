{
  runTest,
  ...
}:
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
in
{
  systemd-boot = runTest (
    { pkgs, ... }: {
      name = "systemd-boot-extra-initrd";

      nodes.machine = { config, ... }: {
        imports = [ common ];

        boot.loader.systemd-boot = {
          enable = true;
          extraInstallCommands = ''
            cp ${canaryCpio pkgs} ${config.boot.loader.efi.efiSysMountPoint}/${extraInitrdPath}
          '';
        };
      };

      inherit testScript;
    }
  );

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
