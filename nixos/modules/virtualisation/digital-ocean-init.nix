{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.virtualisation.digitalOcean;
  defaultConfigFile = pkgs.writeText "digitalocean-configuration.nix" ''
    { modulesPath, lib, ... }:
    {
      imports = lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix ++ [
        (modulesPath + "/virtualisation/digital-ocean-config.nix")
      ];
    }
  '';
in {
  options.virtualisation.digitalOcean.rebuildFromUserData = mkOption {
    type = types.bool;
    default = true;
    example = true;
    description = lib.mdDoc "Whether to reconfigure the system from Digital Ocean user data";
  };
  options.virtualisation.digitalOcean.defaultConfigFile = mkOption {
    type = types.path;
    default = defaultConfigFile;
    defaultText = literalMD ''
      The default configuration imports user-data if applicable and
      `(modulesPath + "/virtualisation/digital-ocean-config.nix")`.
    '';
    description = lib.mdDoc ''
      A path to a configuration file which will be placed at
      `/etc/nixos/configuration.nix` and be used when switching to
      a new configuration.
    '';
  };

  config = {
    systemd.services.digitalocean-init = mkIf cfg.rebuildFromUserData {
      description = "Reconfigure the system from Digital Ocean userdata on startup";
      wantedBy = [ "network-online.target" ];
      unitConfig = {
        ConditionPathExists = "!/etc/nixos/do-userdata.nix";
        After = [ "digitalocean-metadata.service" "network-online.target" ];
        Requires = [ "digitalocean-metadata.service" ];
        X-StopOnRemoval = false;
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      restartIfChanged = false;
      path = [ pkgs.jq pkgs.gnused pkgs.gnugrep config.systemd.package config.nix.package config.system.build.nixos-rebuild ];
      environment = {
        HOME = "/root";
        NIX_PATH = concatStringsSep ":" [
          "/nix/var/nix/profiles/per-user/root/channels/nixos"
          "nixos-config=/etc/nixos/configuration.nix"
          "/nix/var/nix/profiles/per-user/root/channels"
        ];
      };
      script = ''
        set -e
        echo "attempting to fetch configuration from Digital Ocean user data..."
        userData=$(mktemp)
        if jq -er '.user_data' /run/do-metadata/v1.json > $userData; then
          # If the user-data looks like it could be a nix expression,
          # copy it over. Also, look for a magic three-hash comment and set
          # that as the channel.
          if nix-instantiate --parse $userData > /dev/null; then
            channels="$(grep '^###' "$userData" | sed 's|###\s*||')"
            printf "%s" "$channels" | while read channel; do
              echo "writing channel: $channel"
            done

            if [[ -n "$channels" ]]; then
              printf "%s" "$channels" > /root/.nix-channels
              nix-channel --update
            fi

            echo "setting configuration from Digital Ocean user data"
            cp "$userData" /etc/nixos/do-userdata.nix
            if [[ ! -e /etc/nixos/configuration.nix ]]; then
              install -m0644 ${cfg.defaultConfigFile} /etc/nixos/configuration.nix
            fi
          else
            echo "user data does not appear to be a Nix expression; ignoring"
            exit
          fi

          nixos-rebuild switch
        else
          echo "no user data is available"
        fi
        '';
    };
  };
  meta.maintainers = with maintainers; [ arianvp eamsden ];
}
