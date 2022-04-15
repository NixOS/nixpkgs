{ config, lib, ... }: let

  cfg = config.boot.systemd.shutdown;

in {
  options.boot.systemd.shutdown = {
    enable = lib.mkEnableOption "pivoting back to an initramfs for shutdown" // { default = true; };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.generate-shutdown-ramfs = {
      description = "Generate shutdown ramfs";
      before = [ "shutdown.target" ];
      unitConfig = {
        DefaultDependencies = false;
        ConditionFileIsExecutable = [
          "!/run/initramfs/shutdown"
          "/run/current-system/systemd/lib/systemd/systemd-shutdown"
        ];
      };

      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /run/initramfs
        if ! mountpoint -q /run/initramfs; then
          mount -t tmpfs tmpfs /run/initramfs
        fi
        cp /run/current-system/systemd/lib/systemd/systemd-shutdown /run/initramfs/shutdown
      '';
    };
  };
}
