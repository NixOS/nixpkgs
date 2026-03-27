{
  pkgs,
  ...
}:
let
  qemu-img = pkgs.lib.getExe' pkgs.vmTools.qemu "qemu-img";
  empty = pkgs.runCommand "empty.qcow2" { } ''
    ${qemu-img} create -f qcow2 "$out" 32M
  '';
in
{
  name = "iosched";
  meta.maintainers = with pkgs.lib.maintainers; [ mvs ];

  nodes.machine = {
    virtualisation.qemu.options = [
      "-drive"
      "id=sda,if=none,format=qcow2,readonly=on,file=${empty}"
      "-drive"
      "id=sdb,if=none,format=qcow2,readonly=on,file=${empty}"
      "-drive"
      "id=nvme0n1,if=none,format=qcow2,readonly=on,file=${empty}"
      "-drive"
      "id=mmcblk0,if=none,format=qcow2,file=./mmcblk0.qcow2"
      "-device"
      "virtio-scsi-pci,id=scsi0"
      "-device"
      "sdhci-pci"
      "-device"
      "scsi-hd,rotation_rate=1,bus=scsi0.0,drive=sda"
      "-device"
      "scsi-hd,rotation_rate=7200,bus=scsi0.0,drive=sdb"
      "-device"
      "sd-card,drive=mmcblk0"
      "-device"
      "nvme,serial=deadbeef,drive=nvme0n1"
    ];

    hardware.block = {
      defaultScheduler = "none";
      defaultSchedulerRotational = "mq-deadline";
      scheduler = {
        "nvme[0-9]*" = "kyber";
        "mmcblk[0-9]*" = "bfq";
      };
    };
  };

  testScript = ''
    import subprocess

    def check_scheduler(dev, scheduler):
      machine.succeed("grep -F -q '[{}]' /sys/block/{}/queue/scheduler".format(scheduler, dev))

    subprocess.check_call([
      "${qemu-img}", "create", "-f", "qcow2", "vm-state-machine/mmcblk0.qcow2", "32M"
    ])

    machine.start()
    machine.succeed("udevadm verify --no-style")
    check_scheduler("sda", "none")
    check_scheduler("sdb", "mq-deadline")
    check_scheduler("nvme0n1", "kyber")
    check_scheduler("mmcblk0", "bfq")

    machine.succeed("tmp=\"$(mktemp)\"; losetup /dev/loop0 \"$tmp\"")
    check_scheduler("loop0", "none")
  '';
}
