{ config, lib, pkgs, ... }:

with lib;

let cfg = config.system.notifyUpdates;

in
{
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
        #default = null;
        example = "https://nixos.org/channels/nixos-unstable";
        description = ''
          The URI of the NixOS channel to use for checking updates.
          By default, this is the channel set using
          <command>nix-channel</command> (run <literal>nix-channel
          --list</literal> to see the current value).
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

      path = with pkgs; [
        coreutils
        curl
        libnotify
      ];

      script = ''
        current=$(cat /nix/var/nix/profiles/system/nixos-version | sed 's/.*\.\([0-9a-f]*\)$/\1/')
        length=$(echo -n $current | wc -c)

        incoming=$(curl -L ${cfg.channel}/git-revision)
        incoming=$(echo -n $incoming | cut -c 1-$length)

        if ! [ $incoming = $current ]; then
          notify-send "Update Available" "Incoming git revision: $incoming\nCurrent git revision: $current"
        fi
      '';
    };
  };
}
