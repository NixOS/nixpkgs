{ config, lib, pkgs, ... }:

let
  cfg = config.boot.initrd.unl0kr;
in
{
  options.boot.initrd.unl0kr = {
    enable = lib.mkEnableOption "unl0kr in initrd" // {
      description = ''
        Whether to enable the unl0kr on-screen keyboard in initrd to unlock LUKS.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    meta.maintainers = with lib.maintainers; [ tomfitzhenry ];
    assertions = [
      {
        assertion = cfg.enable -> config.boot.initrd.systemd.enable;
        message = "boot.initrd.unl0kr is only supported with boot.initrd.systemd.";
      }
    ];

    boot.initrd.systemd = {
      storePaths = with pkgs; [
        "${pkgs.gnugrep}/bin/grep"
        libinput
        xkeyboard_config
        "${config.boot.initrd.systemd.package}/lib/systemd/systemd-reply-password"
        "${pkgs.unl0kr}/bin/unl0kr"
      ];
      services = {
        unl0kr-ask-password = {
          description = "Forward Password Requests to unl0kr";
          conflicts = [
            "emergency.service"
            "initrd-switch-root.target"
            "shutdown.target"
          ];
          unitConfig.DefaultDependencies = false;
          after = [
            "systemd-vconsole-setup.service"
            "udev.service"
          ];
          before = [
            "shutdown.target"
          ];
          script = ''
            # This script acts as a Password Agent: https://systemd.io/PASSWORD_AGENTS/

            DIR=/run/systemd/ask-password/
            # If a user has multiple encrypted disks, the requests might come in different times,
            # so make sure to answer as many requests as we can. Once boot succeeds, other
            # password agents will be responsible for watching for requests.
            while [ -d $DIR ] && [ "$(ls -A $DIR/ask.*)" ];
            do
              for file in `ls $DIR/ask.*`; do
                socket="$(cat "$file" | ${pkgs.gnugrep}/bin/grep "Socket=" | cut -d= -f2)"
                ${pkgs.unl0kr}/bin/unl0kr | ${config.boot.initrd.systemd.package}/lib/systemd/systemd-reply-password 1 "$socket"
              done
            done
          '';
        };
      };

      paths = {
        unl0kr-ask-password = {
          description = "Forward Password Requests to unl0kr";
          conflicts = [
            "emergency.service"
            "initrd-switch-root.target"
            "shutdown.target"
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
