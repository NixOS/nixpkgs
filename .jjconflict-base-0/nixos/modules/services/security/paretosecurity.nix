{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.paretosecurity;
in
{

  options.services.paretosecurity = {
    enable = lib.mkEnableOption "[ParetoSecurity](https://paretosecurity.com) [agent](https://github.com/ParetoSecurity/agent) and its root helper";
    package = lib.mkPackageOption pkgs "paretosecurity" { };
    trayIcon = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Set to false to disable the tray icon and run as a CLI tool only.";
    };
    users = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            inviteId = lib.mkOption {
              type = lib.types.str;
              description = ''
                A unique ID that links the agent to Pareto Cloud.
                Get it from the Join Team page on `https://cloud.paretosecurity.com/team/join/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.
                In Step 2, under Linux tab, enter your email then copy it from the generated command.
              '';
              example = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
            };
          };
        }
      );
      default = { };
      description = "Per-user Pareto Security configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    # In traditional Linux distributions, systemd would read the [Install] section from
    # unit files and automatically create the appropriate symlinks to enable services.
    # However, in NixOS, due to its immutable nature and the way the Nix store works,
    # the [Install] sections are not processed during system activation. Instead, we
    # must explicitly tell NixOS which units to enable by specifying their target
    # dependencies here. This creates the necessary symlinks in the proper locations.
    systemd.sockets.paretosecurity.wantedBy = [ "sockets.target" ];

    # In NixOS, systemd services are configured with minimal PATH. However,
    # paretosecurity helper looks for installed software to do its job, so
    # it needs the full system PATH. For example, it runs `iptables` to see if
    # firewall is configured. And it looks for various password managers to see
    # if one is installed.
    # The `paretosecurity-user` timer service that is configured lower has
    # the same need.
    systemd.services = {
      paretosecurity.serviceConfig.Environment = [
        "PATH=${config.system.path}/bin:${config.system.path}/sbin"
      ];
    }
    // (

      # Each user can set their inviteID, which creates a systemd service
      # that runs `paretosecurity link ...` to link their device to Pareto Cloud.
      lib.mapAttrs' (
        username: userConfig:
        lib.nameValuePair "paretosecurity-link-${username}" {
          description = "Link Pareto Desktop to Pareto Cloud for user ${username}";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = username;
            StateDirectory = "paretosecurity/${username}";

            ExecStart = pkgs.writeShellScript "paretosecurity-link-${username}" ''
              set -euo pipefail

              INVITE_ID="${userConfig.inviteId}"
              STATE_FILE="/var/lib/paretosecurity/${username}/linked-$INVITE_ID"
              CONFIG_FILE="$HOME/.config/pareto.toml"

              # Check if already linked with this specific invite
              if [ -f "$STATE_FILE" ]; then
                echo "Device already linked with invite $INVITE_ID for user ${username}"
                exit 0
              fi

              # Ensure config directory exists
              mkdir -p "$(dirname "$CONFIG_FILE")"

              # Perform linking
              echo "Linking device to Pareto Cloud for user ${username}..."
              ${cfg.package}/bin/paretosecurity link \
                "paretosecurity://linkDevice/?invite_id=$INVITE_ID"

              # Verify linking succeeded
              if [ -f "$CONFIG_FILE" ] && grep -q "TeamID" "$CONFIG_FILE"; then
                echo "Successfully linked to Pareto Cloud for user ${username}"
                touch "$STATE_FILE"
              else
                echo "Failed to link to Pareto Cloud for user ${username}"
                exit 1
              fi
            '';
          };

          wantedBy = [ "multi-user.target" ];
        }
      ) cfg.users
    );

    # Enable the tray icon and timer services if the trayIcon option is enabled
    systemd.user = lib.mkIf cfg.trayIcon {
      services = {
        paretosecurity-trayicon.wantedBy = [ "graphical-session.target" ];
        paretosecurity-user = {
          wantedBy = [ "graphical-session.target" ];
          serviceConfig.Environment = [
            "PATH=${config.system.path}/bin:${config.system.path}/sbin"
          ];
        };
      };
      timers.paretosecurity-user.wantedBy = [ "timers.target" ];
    };
  };
}
