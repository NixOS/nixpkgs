# This module allows the test driver to connect to the virtual machine
# via a root shell attached to port 514.

{ config, lib, pkgs, ... }:

with lib;
with import ../../lib/qemu-flags.nix { inherit pkgs; };

{

  # This option is a dummy that if used in conjunction with
  # modules/virtualisation/qemu-vm.nix gets merged with the same option defined
  # there and only is declared here because some modules use
  # test-instrumentation.nix but not qemu-vm.nix.
  #
  # One particular example are the boot tests where we want instrumentation
  # within the images but not other stuff like setting up 9p filesystems.
  options.virtualisation.qemu.program = mkOption { type = types.path; };

  config = {

    systemd.services.backdoor =
      { wantedBy = [ "multi-user.target" ];
        requires = [ "dev-hvc0.device" "dev-${qemuSerialDevice}.device" ];
        after = [ "dev-hvc0.device" "dev-${qemuSerialDevice}.device" ];
        script =
          ''
            export USER=root
            export HOME=/root
            export DISPLAY=:0.0

            source /etc/profile

            # Don't use a pager when executing backdoor
            # actions. Because we use a tty, commands like systemctl
            # or nix-store get confused into thinking they're running
            # interactively.
            export PAGER=

            cd /tmp
            exec < /dev/hvc0 > /dev/hvc0
            while ! exec 2> /dev/${qemuSerialDevice}; do sleep 0.1; done
            echo "connecting to host..." >&2
            stty -F /dev/hvc0 raw -echo # prevent nl -> cr/nl conversion
            echo
            PS1= exec /bin/sh
          '';
        serviceConfig.KillSignal = "SIGHUP";
      };

    # Prevent agetty from being instantiated on the serial device, since it
    # interferes with the backdoor (writes to it will randomly fail
    # with EIO).  Likewise for hvc0.
    systemd.services."serial-getty@${qemuSerialDevice}".enable = false;
    systemd.services."serial-getty@hvc0".enable = false;

    # Only use a serial console, no TTY.
    virtualisation.qemu.consoles = [ qemuSerialDevice ];

    boot.initrd.preDeviceCommands =
      ''
        echo 600 > /proc/sys/kernel/hung_task_timeout_secs
      '';

    boot.initrd.postDeviceCommands =
      ''
        # Using acpi_pm as a clock source causes the guest clock to
        # slow down under high host load.  This is usually a bad
        # thing, but for VM tests it should provide a bit more
        # determinism (e.g. if the VM runs at lower speed, then
        # timeouts in the VM should also be delayed).
        echo acpi_pm > /sys/devices/system/clocksource/clocksource0/current_clocksource
      '';

    boot.postBootCommands =
      ''
        # Panic on out-of-memory conditions rather than letting the
        # OOM killer randomly get rid of processes, since this leads
        # to failures that are hard to diagnose.
        echo 2 > /proc/sys/vm/panic_on_oom

        # Coverage data is written into /tmp/coverage-data.
        mkdir -p /tmp/xchg/coverage-data
      '';

    # If the kernel has been built with coverage instrumentation, make
    # it available under /proc/gcov.
    boot.kernelModules = [ "gcov-proc" ];

    # Panic if an error occurs in stage 1 (rather than waiting for
    # user intervention).
    boot.kernelParams =
      [ "console=${qemuSerialDevice}" "panic=1" "boot.panic_on_fail" ];

    # `xwininfo' is used by the test driver to query open windows.
    environment.systemPackages = [ pkgs.xorg.xwininfo ];

    # Log everything to the serial console.
    services.journald.extraConfig =
      ''
        ForwardToConsole=yes
        MaxLevelConsole=debug
      '';

    systemd.extraConfig = ''
      # Don't clobber the console with duplicate systemd messages.
      ShowStatus=no
      # Allow very slow start
      DefaultTimeoutStartSec=300
    '';

    boot.consoleLogLevel = 7;

    # Prevent tests from accessing the Internet.
    networking.defaultGateway = mkOverride 150 "";
    networking.nameservers = mkOverride 150 [ ];

    systemd.globalEnvironment.GCOV_PREFIX = "/tmp/xchg/coverage-data";

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "SERIAL_8250_CONSOLE")
      (isYes "SERIAL_8250")
      (isEnabled "VIRTIO_CONSOLE")
    ];

    networking.usePredictableInterfaceNames = false;

    # Make it easy to log in as root when running the test interactively.
    users.users.root.initialHashedPassword = mkOverride 150 "";

    services.xserver.displayManager.job.logToJournal = true;

    # set default stateVersion to avoid warnings during eval
    system.stateVersion = mkDefault "18.03";
  };

}
