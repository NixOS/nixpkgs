{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.virtualisation.amazon-init;

  script = ''
    #!${pkgs.runtimeShell} -eu

    echo "attempting to fetch configuration from EC2 user data..."

    export HOME=/root
    export PATH=${
      pkgs.lib.makeBinPath [
        config.nix.package
        config.systemd.package
        pkgs.gnugrep
        pkgs.git
        pkgs.gnutar
        pkgs.gzip
        pkgs.gnused
        pkgs.xz
        config.system.build.nixos-rebuild
      ]
    }:$PATH
    export NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels

    userData=/etc/ec2-metadata/user-data

    # Check if user-data looks like a shell script and execute it with the
    # runtime shell if it does. Otherwise treat it as a nixos configuration
    # expression
    if IFS= LC_ALL=C read -rN2 shebang < $userData && [ "$shebang" = '#!' ]; then
      # NB: we cannot chmod the $userData file, this is why we execute it via
      # `pkgs.runtimeShell`. This means we have only limited support for shell
      # scripts compatible with the `pkgs.runtimeShell`.
      exec ${pkgs.runtimeShell} $userData
    fi

    if [ -s "$userData" ]; then
      # If the user-data looks like it could be a nix expression,
      # copy it over. Also, look for a magic three-hash comment and set
      # that as the channel.
      if sed '/^\(#\|SSH_HOST_.*\)/d' < "$userData" | grep -q '\S'; then
        channels="$(grep '^###' "$userData" | sed 's|###\s*||')"
        while IFS= read -r channel; do
          echo "writing channel: $channel"
        done < <(printf "%s\n" "$channels")

        if [[ -n "$channels" ]]; then
          printf "%s" "$channels" > /root/.nix-channels
          nix-channel --update
        fi

        echo "setting configuration from EC2 user data"
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
in
{

  options.virtualisation.amazon-init = {
    enable = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Enable or disable the amazon-init service.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.amazon-init = {
      inherit script;
      description = "Reconfigure the system from EC2 userdata on startup";

      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
      requires = [ "network-online.target" ];

      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
  meta.maintainers = with maintainers; [ arianvp ];
}
