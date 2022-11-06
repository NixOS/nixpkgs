{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.boot.initrd.osk-sdl;
in
{
  options.boot.initrd.osk-sdl = {
    enable = mkEnableOption (lib.mdDoc "osk-sdl in initrd") // {
      description = lib.mdDoc ''
        Whether to enable the osk-sdl on-screen keyboard in initrd to unlock LUKS.
      '';
    };
  };

  config = mkIf cfg.enable {
    meta.maintainers = with maintainers; [ tomfitzhenry ];
    assertions = [
      {
        assertion = cfg.enable -> config.boot.initrd.systemd.enable;
        message = "boot.initrd.osk-sdl is only supported with boot.initrd.systemd.";
      }
    ];
    boot.initrd.availableKernelModules = [
      "evdev" # for entering pw
    ];

    boot.initrd.systemd = {
      storePaths = with pkgs; [
        dejavu_fonts
        gnugrep
        libGL
        mesa.drivers
        osk-sdl
        "${systemd}/lib/systemd/systemd-reply-password"
      ];
      services = {
        osk-sdl-ask-password = {
          description = "Forward Password Requests to OSK-SDL";
          conflicts = [
            "shutdown.target"
            "emergency.service"
          ];
          unitConfig.DefaultDependencies = false;
          after = [
            "systemd-vconsole-setup.service"
          ];
          before = [
            "shutdown.target"
          ];
          script = ''
            mkdir -p /run/opengl-driver/
            cp -r ${pkgs.mesa.drivers}/* /run/opengl-driver/

            for file in `ls /run/systemd/ask-password/*`; do
              socket="$(cat "$file" | ${pkgs.gnugrep}/bin/grep "Socket=" | cut -d= -f2)"
              ${pkgs.osk-sdl}/bin/osk-sdl -c ${pkgs.osk-sdl}/etc/osk.conf -d x -n x -k -s | ${pkgs.systemd}/lib/systemd/systemd-reply-password 1 "$socket"
            done
          '';
        };
      };

      paths = {
        osk-sdl-ask-password = {
          description = "Forward Password Requests to OSK-SDL";
          conflicts = [
            "shutdown.target"
            "emergency.service"
          ];
          unitConfig.DefaultDependencies = false;
          before = [
            "shutdown.target"
            "paths.target"
            "cryptsetup.target"
          ];
          wantedBy = [ "sysinit.target" ];
          pathConfig = {
            DirectoryNotEmpty = "/run/systemd/ask-password";
            MakeDirectory = true;
          };
        };
      };
    };
  };
}
