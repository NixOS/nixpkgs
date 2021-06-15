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
        #default = null;
        example = "https://nixos.org/channels/nixos-unstable";
        description = ''
          The URI of the NixOS channel to use for checking updates.
          By default, this is the channel set using
          <command>nix-channel</command> (run <literal>nix-channel
          --list</literal> to see the current value).
        '';
      };

      dates = mkOption {
        default = "04:40";
        type = types.str;
        description = ''
          Specification (in the format described by
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>) of the time at
          which the update will occur.
        '';
      };

      randomizedDelaySec = mkOption {
        default = "0";
        type = types.str;
        example = "45min";
        description = ''
          Add a randomized delay before each automatic upgrade.
          The delay will be chozen between zero and this value.
          This value must be a time span in the format specified by
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.nixos-notify-updates = {
      description = "Notify available NixOS Updates";

      restartIfChanged = true; # not sure

      serviceConfig.Type = "oneshot";

      environment = config.nix.envVars // {
        inherit (config.environment.sessionVariables) NIX_PATH;
        #HOME="/root";
      };

      path = with pkgs; [
        coreutils
        curl

      ];

      script = ''
        current="$(cat /nix/var/nix/profiles/system/nixos-version | sed 's/.*\.\([0-9a-f]*\)$/\1/')"
        length="$(echo -n $current | wc -c)"
        
        incoming="$(curl -L $CHANNEL/git-revision)"
        incoming="$(echo -n $incoming | cut -c 1-$length)"
        
        if ! [ "$incoming" = "$current" ]; then
          # to change
          wall "UPDATE AVAILABLE" "Incoming git revision: $incoming, current git revision: $current"
        fi
      '';

      startAt = cfg.dates;
      
    };

    systemd.timers.notify-updates.timerConfig.RandomizedDelaySec = 
      cfg.randomizedDelaySec;
  };
}
