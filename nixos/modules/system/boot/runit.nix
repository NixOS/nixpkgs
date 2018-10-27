{ config, pkgs, stdenv, lib, ... }:

with lib;
{

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
  };

  config =
    let runit = config.runit.package;
        poweroff = pkgs.writeScript "runit-poweroff" ''
          ${lib.getBin runit}/bin/runit-init 0
        '';
    in mkIf config.runit.enable {
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

      system.init.extraSystemBuilderCmds = "";

      boot.startInitCommands = ''
        echo "starting runit..."
        PATH="$PATH:/run/current-system/sw/bin/" runit-init
      '';
    };

}
