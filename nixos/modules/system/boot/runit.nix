{ config, pkgs, stdenv, lib, ... }:

with lib;
with import ./runit-lib.nix { inherit pkgs lib; runit = config.runit.package; };

{

  # TODO
  #   - Logging
  #   - Networknig
  #   - SSH

  options = {
    runit.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the runit init system.";
    };

    runit.package = mkOption {
      type = types.package;
      default = pkgs.runit;
      description = "Runit package.";
    };

    runit.services = mkOption {
      default = {};
      type = types.attrsOf ( types.submodule serviceConfig );
      description = "Definition of runit services";
    };
  };

  config =
    let runit = config.runit.package;
        poweroff = pkgs.writeScript "runit-poweroff" ''
          ${lib.getBin runit}/bin/runit-init 0
        '';

        runit1 = pkgs.writeScript "runit1" ''
          #!${pkgs.runtimeShell} -e
          echo "Runit1"
        '';

        runit2 = pkgs.writeScript "runit2" ''
          #!${pkgs.runtimeShell} -e
          echo "Running runsvdir"
          ${pkgs.coreutils}/bin/ls -l /etc/sv
          exec runsvdir -P /etc/sv/
        '';

        runit3 = pkgs.writeScript "runit3" ''
          #!${pkgs.runtimeShell} -e
          echo 'Shutting down'

          sv force-stop /etc/sv/*
          sv exit /etc/sv/*

          echo 'Sending SIGTERM to all processes...'
          ${pkgs.procps}/bin/pkill --inverse -s0,1 -TERM
          sleep 1 # TODO allow configure
          echo 'Sending SIGKILL to all processes...'
          ${pkgs.procps}/bin/pkill --inverse -s0,1 -KILL

          ${pkgs.utillinux}/bin/swapoff -a
          ${pkgs.utillinux}/bin/umount -r -a -t nosysfs,noproc,nodevtmpfs,notmpfs

          echo 'Remount root read only...'
          ${pkgs.utillinux}/bin/mount -o remount,ro /

          echo 'Syncing file systems'
          sync
        '';
    in mkIf config.runit.enable {
      assertions = concatLists (mapAttrsToList (checkService config.runit.services) config.runit.services);

      warnings =
        lib.optional config.networking.useDHCP
          "runit does not support automatic network interface detection. Please list your network interfaces manually";

      environment.systemPackages = [ config.runit.package ];

      boot.kernel.sysctl."kernel.poweroff_cmd" = "${poweroff}";

      services.udev.package = pkgs.eudev;
      services.udev.udevd = "udevd";
      services.udev.udevdPath = "${config.services.udev.package}/bin/udevd";
      services.udev.builtinUdevRulesCommands = ''
        cp -v ${config.services.udev.package}/var/lib/udev/rules.d/60-cdrom_id.rules $out/
        cp -v ${config.services.udev.package}/var/lib/udev/rules.d/60-persistent-storage.rules $out/
        cp -v ${config.services.udev.package}/var/lib/udev/rules.d/80-drivers.rules $out/
      '';

      nixpkgs.overlays = [
        (self: super: {
           udev = super.eudev;

           procps = super.procps.override { withSystemd = false; };

           utillinux = super.utillinux.override { systemd = null; };

           lvm2 = super.lvm2.override { enable_systemd = false; systemd = null;
                                        udev = config.services.udev.package; };

           dbus = super.dbus.override { systemdSupport = false; };

           libusb1 = super.libusb1.override { systemdSupport = false; systemd = null; };

         })
      ];

      system.init.extraSystemBuilderCmds = ''
         mkdir -p $out/var/run/runit
      '';

      boot.startInitCommands = ''
        echo "starting runit..."
        ${pkgs.coreutils}/bin/mkdir -p $out/var/run/runit
        ${pkgs.utillinux}/bin/mount -t tmpfs -o size=16m tmpfs /var/run/runit

        PATH="$PATH:/run/current-system/sw/bin/" exec runit-init
      '';

      environment.etc =
        listToAttrs (mapAttrsToList makeService config.runit.services) //
        { "runit/.keep" = { text = ""; };
          "runit/1" = { source = runit1; };
          "runit/2" = { source = runit2; };
          "runit/3" = { source = runit3; };
        };
    };

}
