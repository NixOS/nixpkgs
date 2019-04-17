{ config, pkgs, lib, ... }:
with lib;
{
  options.virtualisation.digitalOcean.rebuildFromUserData = mkOption {
    type = bool;
    enable = true;
    example = true;
    description = "Whether to reconfigure the system from Digital Ocean user data";
  };

  config = {
    systemd.services.digital-ocean-init = {
      description = "Reconfigure the system from Digital Ocean uesrdata on startup";
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        ConditionFileExists = "!/etc/nixos/configuration.nix";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      restartIfChanged = false;
      path = [ pkgs.curl pkgs.gnused pkgs.gnugrep pkgs.systemd config.nix.package config.system.build.nixos-rebuild ];
      script = ''
        set -e
        echo "attempting to fetch configuration from Digital Ocean user data..."
        export HOME=/root
        export NIX_PATH=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels
        userData=$(mktemp)
        if curl --retry-connrefused --output $userData http://169.254.169.254/metadata/v1/user-data; then
          # If the user-data looks like it could be a nix expression,
          # copy it over. Also, look for a magic three-hash comment and set
          # that as the channel.
          if sed '/^\(#\|SSH_HOST_.*\)/d' < "$userData" | grep -q '\S'; then
            channels="$(grep '^###' "$userData" | sed 's|###\s*||')"
            printf "%s" "$channels" | while read channel; do
              echo "writing channel: $channel"
            done

            if [[ -n "$channels" ]]; then
              printf "%s" "$channels" > /root/.nix-channels
              nix-channel --update
            fi

            echo "setting configuration from Digital Ocean user data"
            cp "$userData" /etc/nixos/configuration.nix
          else
            echo "user data does not appear to be a Nix expression; ignoring"
            exit
          fi
        else
          echo "no user data is available"
          exit
        fi

        nixos-rebuild switch
        '';
    };
  };
  meta.maintainers = with maintainers; [ arianvp eamsden ];
}
