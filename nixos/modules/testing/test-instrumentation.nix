# This module allows the test driver to connect to the virtual machine
# via a root shell attached to port 514.

{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.testing;

  qemu-common = import ../../lib/qemu-common.nix { inherit lib pkgs; };

  backdoorService = {
    requires = [ "dev-hvc0.device" "dev-${qemu-common.qemuSerialDevice}.device" ];
    after = [ "dev-hvc0.device" "dev-${qemu-common.qemuSerialDevice}.device" ];
    script =
      ''
        export USER=root
        export HOME=/root
        export DISPLAY=:0.0

        if [[ -e /etc/profile ]]; then
            source /etc/profile
        fi

        # Don't use a pager when executing backdoor
        # actions. Because we use a tty, commands like systemctl
        # or nix-store get confused into thinking they're running
        # interactively.
        export PAGER=

        cd /tmp
        exec < /dev/hvc0 > /dev/hvc0
        while ! exec 2> /dev/${qemu-common.qemuSerialDevice}; do sleep 0.1; done
        echo "connecting to host..." >&2
        stty -F /dev/hvc0 raw -echo # prevent nl -> cr/nl conversion
        # The following line is essential since it signals to
        # the test driver that the shell is ready.
        # See: the connect method in the Machine class.
        echo "Spawning backdoor root shell..."
        # Passing the terminal device makes bash run non-interactively.
        # Otherwise we get errors on the terminal because bash tries to
        # setup things like job control.
        # Note: calling bash explicitly here instead of sh makes sure that
        # we can also run non-NixOS guests during tests.
        PS1= exec /usr/bin/env bash --norc /dev/hvc0
      '';
      serviceConfig.KillSignal = "SIGHUP";
  };

in

{

  options.testing = {

    initrdBackdoor = lib.mkEnableOption (lib.mdDoc ''
      enable backdoor.service in initrd. Requires
      boot.initrd.systemd.enable to be enabled. Boot will pause in
      stage 1 at initrd.target, and will listen for commands from the
      Machine python interface, just like stage 2 normally does. This
      enables commands to be sent to test and debug stage 1. Use
      machine.switch_root() to leave stage 1 and proceed to stage 2.
    '');

  };

  config = {

    assertions = [
      {
        assertion = cfg.initrdBackdoor -> config.boot.initrd.systemd.enable;
        message = ''
          testing.initrdBackdoor requires boot.initrd.systemd.enable to be enabled.
        '';
      }
    ];

    systemd.services.backdoor = lib.mkMerge [
      backdoorService
      {
        wantedBy = [ "multi-user.target" ];
      }
    ];

    boot.initrd.systemd = lib.mkMerge [
      {
        contents."/etc/systemd/journald.conf".text = ''
          [Journal]
          ForwardToConsole=yes
          MaxLevelConsole=debug
        '';

        extraConfig = config.systemd.extraConfig;
      }

      (lib.mkIf cfg.initrdBackdoor {
        # Implemented in machine.switch_root(). Suppress the unit by
        # making it a noop without removing it, which would break
        # initrd-parse-etc.service
        services.initrd-cleanup.serviceConfig.ExecStart = [
          # Reset
          ""
          # noop
          "/bin/true"
        ];

        services.backdoor = lib.mkMerge [
          backdoorService
          {
            # TODO: Both stage 1 and stage 2 should use these same
            # settings. But a lot of existing tests rely on
            # backdoor.service having default orderings,
            # e.g. systemd-boot.update relies on /boot being mounted
            # as soon as backdoor starts. But it can be useful for
            # backdoor to start even earlier.
            wantedBy = [ "sysinit.target" ];
            unitConfig.DefaultDependencies = false;
            conflicts = [ "shutdown.target" "initrd-switch-root.target" ];
            before = [ "shutdown.target" "initrd-switch-root.target" ];
          }
        ];

        contents."/usr/bin/env".source = "${pkgs.coreutils}/bin/env";
      })
    ];

    # Prevent agetty from being instantiated on the serial device, since it
    # interferes with the backdoor (writes to it will randomly fail
    # with EIO).  Likewise for hvc0.
    systemd.services."serial-getty@${qemu-common.qemuSerialDevice}".enable = false;
    systemd.services."serial-getty@hvc0".enable = false;

    # Only set these settings when the options exist. Some tests (e.g. those
    # that do not specify any nodes, or an empty attr set as nodes) will not
    # have the QEMU module loaded and thuse these options can't and should not
    # be set.
    virtualisation = lib.optionalAttrs (options ? virtualisation.qemu) {
      qemu = {
        # Only use a serial console, no TTY.
        # NOTE: optionalAttrs
        #       test-instrumentation.nix appears to be used without qemu-vm.nix, so
        #       we avoid defining consoles if not possible.
        # TODO: refactor such that test-instrumentation can import qemu-vm
        #       or declare virtualisation.qemu.console option in a module that's always imported
        consoles = [ qemu-common.qemuSerialDevice ];
        package  = lib.mkDefault pkgs.qemu_test;
      };
    };

    boot.kernel.sysctl = {
      "kernel.hung_task_timeout_secs" = 600;
      # Panic on out-of-memory conditions rather than letting the
      # OOM killer randomly get rid of processes, since this leads
      # to failures that are hard to diagnose.
      "vm.panic_on_oom" = lib.mkDefault 2;
    };

    boot.kernelParams = [
      "console=${qemu-common.qemuSerialDevice}"
      # Panic if an error occurs in stage 1 (rather than waiting for
      # user intervention).
      "panic=1" "boot.panic_on_fail"
      # Using acpi_pm as a clock source causes the guest clock to
      # slow down under high host load.  This is usually a bad
      # thing, but for VM tests it should provide a bit more
      # determinism (e.g. if the VM runs at lower speed, then
      # timeouts in the VM should also be delayed).
      "clock=acpi_pm"
    ];

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
      DefaultDeviceTimeoutSec=300
    '';
    systemd.user.extraConfig = ''
      # Allow very slow start
      DefaultTimeoutStartSec=300
      DefaultDeviceTimeoutSec=300
    '';

    boot.consoleLogLevel = 7;

    # Prevent tests from accessing the Internet.
    networking.defaultGateway = mkOverride 150 null;
    networking.nameservers = mkOverride 150 [ ];

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "SERIAL_8250_CONSOLE")
      (isYes "SERIAL_8250")
      (isEnabled "VIRTIO_CONSOLE")
    ];

    networking.usePredictableInterfaceNames = false;

    # Make it easy to log in as root when running the test interactively.
    users.users.root.initialHashedPassword = mkOverride 150 "";

    services.xserver.displayManager.job.logToJournal = true;

    # Make sure we use the Guest Agent from the QEMU package for testing
    # to reduce the closure size required for the tests.
    services.qemuGuest.package = pkgs.qemu_test.ga;

    # Squelch warning about unset system.stateVersion
    system.stateVersion = lib.mkDefault lib.trivial.release;
  };

}
