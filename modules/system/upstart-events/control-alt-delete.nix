{ config, pkgs, ... }:

###### implementation

{
  jobs.control_alt_delete =
    { name = "control-alt-delete";

      startOn = "control-alt-delete";

      task = true;

      script =
        ''
          shutdown -r now 'Ctrl-Alt-Delete pressed'
        '';
    };

  system.activationScripts.poweroff =
    ''
      # Allow the kernel to find the poweroff command.  This is used
      # (for instance) by Xen's "xm shutdown" command to signal a
      # guest to shut down cleanly.
      echo ${config.system.build.upstart}/sbin/poweroff > /proc/sys/kernel/poweroff_cmd
    '';
}
