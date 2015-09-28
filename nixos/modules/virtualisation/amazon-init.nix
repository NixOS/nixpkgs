{ config, pkgs, modulesPath, ... }:

# This attempts to pull a nix expression from this EC2 instance's user-data.

let
  bootScript = pkgs.writeScript "bootscript.sh" ''
    #!${pkgs.stdenv.shell} -eux

    echo "attempting to fetch configuration from user-data..."

    export PATH=${config.nix.package}/bin:${pkgs.wget}/bin:${pkgs.systemd}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin:${config.system.build.nixos-rebuild}/bin:$PATH
    export NIX_PATH=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels

    userData="$(mktemp)"
    wget -q --wait=1 --tries=0 --retry-connrefused -O - http://169.254.169.254/2011-01-01/user-data > "$userData"

    if [[ $? -eq 0 ]]; then
      echo "user-data fetched"
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

        echo "setting configuration"
        cp "$userData" /etc/nixos/configuration.nix
      else
        echo "user-data does not appear to be a nix expression; ignoring"
      fi
    else
      echo "failed to fetch user-data"
    fi

    type -f nixos-rebuild

    nixos-rebuild switch
  '';
in {
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
  boot.postBootCommands = ''
    ${bootScript} &
  '';
}
