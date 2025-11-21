{ lib, pkgs, ... }:
{
  name = "btrbk-no-timer";
  meta.maintainers = with lib.maintainers; [ oxalica ];

  nodes.machine =
    { ... }:
    {
      environment.systemPackages = with pkgs; [ btrfs-progs ];
      services.btrbk.instances.local = {
        onCalendar = null;
        settings.volume."/mnt" = {
          snapshot_dir = "btrbk/local";
          subvolume = "to_backup";
        };
      };
    };

  testScript = ''
    start_all()

    # Create btrfs partition at /mnt
    machine.succeed("truncate --size=128M /data_fs")
    machine.succeed("mkfs.btrfs /data_fs")
    machine.succeed("mkdir /mnt")
    machine.succeed("mount /data_fs /mnt")
    machine.succeed("btrfs subvolume create /mnt/to_backup")
    machine.succeed("mkdir -p /mnt/btrbk/local")

    # The service should not have any triggering timer.
    unit = machine.get_unit_info('btrbk-local.service')
    assert "TriggeredBy" not in unit

    # Manually starting the service should still work.
    machine.succeed("echo foo > /mnt/to_backup/bar")
    machine.start_job("btrbk-local.service")
    machine.wait_until_succeeds("cat /mnt/btrbk/local/*/bar | grep foo")
  '';
}
