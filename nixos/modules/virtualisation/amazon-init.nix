{ config, pkgs, lib, ... }:

with lib;

let
  markerPath = "/etc/nixos/.user-data-applied";

  markerVariable = "NIXOS_USERDATA_MARKER";

  markerMessage = ''
    This file is a marker that this system has started with the 'ec2.userData' option
    set to 'once' before and will therefore not copy its configuration from
    potentially provided user data upon subsequent starts with the option set to
    'once'.
  '';

  script = ''
    #!${pkgs.runtimeShell} -eu

    export HOME=/root
    export PATH=${makeBinPath [ config.nix.package pkgs.systemd pkgs.gnugrep pkgs.gnused config.system.build.nixos-rebuild]}:$PATH
    export NIX_PATH=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels

    userData=/etc/ec2-metadata/user-data

    if [-z "$${markerVariable}"] || [ ! -e "${markerPath}" ]; then
      if [ -s "$userData" ]; then
        echo "attempting to copy configuration from EC2 user data..."

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

          echo "setting configuration from EC2 user data"
          cp "$userData" /etc/nixos/configuration.nix

          if [ -n "$${markerVariable}" ]; then
            echo "${markerMessage}" > "${markerPath}"
          fi

          nixos-rebuild switch
        else
          echo "user data does not appear to be a Nix expression; ignoring"
          exit
        fi
      else
        echo "no EC2 user data to copy configuration from is available"
        exit
      fi
    fi
  '';
in {
  options.ec2.userData = mkOption {
    type = types.enum [ "always" "never" "once" ];
    default = "once";
    description = ''
      Whether to reconfigure the system from EC2 userdata on startup (overwrites the current configuration).
      With <literal>once</literal>, if a file at <filename>${markerPath}</filename> already exists the reconfiguration will be skipped, otherwise it will be applied and the file created.
    '';
  };

  config.systemd.services.amazon-init = mkIf (config.ec2.userData != "never") {
    inherit script;
    description = "Reconfigure the system from EC2 userdata on startup";

    environment.${markerVariable} = mkIf (config.ec2.userData == "once") "true";

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
}
