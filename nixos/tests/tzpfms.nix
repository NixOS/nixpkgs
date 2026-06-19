{ lib, ... }:

{
  name = "tzpfms";

  meta = {
    maintainers = with lib.maintainers; [ toastal ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.jq
        pkgs.parted
        pkgs.tzpfms
      ];

      boot = {
        initrd.systemd.enable = true;
        loader = {
          systemd-boot.enable = true;
          timeout = 0;
          efi.canTouchEfiVariables = true;
        };
        supportedFilesystems = [ "zfs" ];
        zfs = {
          devNodes = "/dev";
          forceImportRoot = lib.mkDefault false;
          requestEncryptionCredentials = false;
        };
      };

      networking.hostId = "deadbeef";

      virtualisation = {
        emptyDiskImages = [ 1024 ];
        mountHostNixStore = true;
        useBootLoader = true;
        useEFIBoot = true;
        tpm.enable = true;
      };

      specialisation.tzpfms-unlock.configuration = {
        boot = {
          kernelParams = [
            "rd.debug"
            "rd.log=all"
          ];
          zfs = {
            devNodes = "/dev";
            requestEncryptionCredentials = false;
            tzpfms = {
              enable = true;
              datasets = [
                "tpmpool/boot"
                "tpmpool/data"
              ];
            };
          };
        };

        virtualisation.fileSystems = {
          "/bootz" = {
            device = "tpmpool/boot";
            fsType = "zfs";
            options = [ "zfsutil" ];
            neededForBoot = true;
          };
          "/dataz" = {
            device = "tpmpool/data";
            fsType = "zfs";
            options = [ "zfsutil" ];
            neededForBoot = false;
          };
        };
      };
    };

  testScript = /* python */ ''
    datasets = ["boot", "data"]

    machine.start(allow_reboot=True)

    machine.wait_for_unit("multi-user.target")

    machine.succeed("test -e /dev/tpm0")
    machine.succeed("test -e /dev/tpmrm0")

    machine.succeed("parted --script /dev/vdb mklabel gpt")
    machine.succeed("parted --script /dev/vdb -- mkpart primary 1M 100%")

    with subtest("Create encrypted ZFS datasets"):
        machine.succeed("zpool create -O mountpoint=none tpmpool /dev/vdb1")
        for ds in datasets:
          machine.succeed("echo aoeuhtns | zfs create -o encryption=aes-128-gcm -o keyformat=passphrase -o mountpoint=/" + ds + "z tpmpool/" + ds)

    with subtest("Wrap keys to TPM with backup"):
        for ds in datasets:
          machine.succeed("printf '\\n\\n' | zfs-tpm2-change-key -b /tmp/tzpfms-backup-" + ds + ".key tpmpool/" + ds)
          machine.succeed("test -f /tmp/tzpfms-backup-" + ds + ".key")
        list = machine.succeed("zfs-tpm-list -H")
        for ds in datasets:
          assert "tpmpool/" + ds in list

    with subtest("Verify backup keys work"):
        for ds in datasets:
          machine.succeed("zfs unmount tpmpool/" + ds + " || true")
          machine.succeed("zfs unload-key tpmpool/" + ds)
          machine.succeed("zfs load-key tpmpool/" + ds + " </tmp/tzpfms-backup-" + ds + ".key")
          assert "available" in machine.succeed("zfs get -Ho value keystatus tpmpool/" + ds)

    with subtest("Verify loading key"):
        # Assertion that the key is loadable, as suggested in the manpage
        for ds in datasets:
          assert "OK" in machine.succeed("zfs-tpm2-load-key -n tpmpool/" + ds)

    with subtest("Switch to tzpfms configuration & reboot"):
        machine.succeed("zpool export tpmpool || true")
        # Set the specialization as the default boot entry
        entry_id = machine.succeed("bootctl list --json=short | jq -r '.[] | select(.title | test(\"tzpfms-unlock\")) | .id'")
        assert id != "", "Missing boot entry"
        machine.succeed("bootctl set-default " + entry_id)
        machine.succeed("sync")
        machine.reboot()

    with subtest("Verify automatic TPM unlock at boot"):
        machine.wait_for_unit("multi-user.target")

        for ds in datasets:
          status = machine.succeed("zfs get -Ho value keystatus tpmpool/" + ds).strip()
          print("tpmpool/" + ds + ": " + status)
          assert status == "available", ds + " key must be auto-loaded"
  '';
}
