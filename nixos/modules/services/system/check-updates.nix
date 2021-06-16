{ config, lib, pkgs, ... }:

with lib;

let cfg = config.system.notifyUpdates;

in {
  options = {
    system.notifyUpdates = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to notify the user when there are NixOS updates available
        '';
      };

      channel = mkOption {
        type = types.str;
        example = "https://nixos.org/channels/nixos-unstable";
        description = ''
          The URI of the NixOS channel to use for checking updates.
          By default, this is the channel set using
          <command>nix-channel</command> (run <literal>nix-channel
          --list</literal> to see the current value).
        '';
      };

      update-available-script = mkOption {
        type = types.nullOr types.str;
        default = ''
          ${pkgs.libnotify}/bin/notify-send -a "Update Notifier" "Update Available" "Incoming git revision: $incoming\nCurrent git revision: $current"
        '';
        description = ''
          Shell script to execute if an update is detected. Git revisions
          for the current and incoming systems are stored in the environment
          variables $current and $incoming (respectfully).
        '';
      };

      up-to-date-script = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = ''
          ${pkgs.libnotify}/bin/notify-send -a "Update Notifier" "System up to date"
        '';
        description = ''
          Shell script to execute if no update is detected. The git revision
          for the current system is stored in environment variable $current.
        '';
      };

      error-script = mkOption {
        type = types.nullOr types.str;
        default = ''
          ${pkgs.libnotify}/bin/notify-send -a "Update Notifier" "Error occured while checking for updates." "$error"
        '';
        description = ''
          Shell script to execute if an error occurs while attempting
          to retrieve updated value. The environment variable $error
          contains the error produced.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.user.services.nixos-notify-updates = {
      description = "Notify available NixOS Updates";

      restartIfChanged = true;

      serviceConfig.Type = "oneshot";

      environment = config.nix.envVars // {
        inherit (config.environment.sessionVariables) NIX_PATH;
      };

      path = with pkgs; [ coreutils curl gnused ];

      script = ''
        if incoming=$(curl -sSNL ${cfg.channel}/git-revision 2>&1) ; then
          current=$(cat /nix/var/nix/profiles/system/nixos-version | sed 's/.*\.\([0-9a-f]*\)$/\1/')
          length=$(echo -n $current | wc -c)

          incoming=$(echo -n $incoming | cut -c 1-$length)
          unset length

          if [ $incoming = $current ]; then
            unset incoming
            ${cfg.up-to-date-script}
          else
            ${cfg.update-available-script}
          fi
        else
          error=$incoming
          unset incoming
          ${cfg.error-script}
        fi
      '';
    };
  };
}
