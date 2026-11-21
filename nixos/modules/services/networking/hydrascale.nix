{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.hydrascale;
  settingsFormat = pkgs.formats.yaml { };
in
{
  meta.maintainers = with lib.maintainers; [ sophronesis ];

  options.services.hydrascale = {
    enable = lib.mkEnableOption "Hydrascale, a daemon that runs several Tailscale tailnets on one host";

    package = lib.mkPackageOption pkgs "hydrascale" { };

    tailscalePackage = lib.mkOption {
      type = lib.types.package;
      default = config.services.tailscale.package;
      defaultText = lib.literalExpression "config.services.tailscale.package";
      description = ''
        The Tailscale package whose `tailscaled` and `tailscale` binaries
        Hydrascale starts inside each network namespace.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options.version = lib.mkOption {
          type = lib.types.int;
          default = 2;
          description = "Schema version of the configuration file.";
        };
      };
      default = { };
      example = lib.literalExpression ''
        {
          tailnets = [
            { id = "work"; }
            {
              id = "homelab";
              control_url = "https://headscale.example.com";
              host_access = true;
            }
          ];
          access = {
            mode = "enforce";
            rules = [
              { from = "work"; to = "internet"; }
              { from = "homelab"; to = "internet"; }
              { from = "host"; to = "homelab"; }
            ];
          };
        }
      '';
      description = ''
        Contents of {file}`/etc/hydrascale/config.yaml`. See the
        [configuration reference](https://github.com/Crank-Git/Hydrascale#configuration-reference)
        for the available keys.

        The file is installed as a regular, writable file rather than a
        store symlink, because Hydrascale rewrites it (the web console edits
        local rules, and a file without an `access` key is migrated in place).
        Every activation resets it to the value of this option.

        Do not put credentials here. Auth keys and API credentials belong in
        the root-only file named by `secrets_file`
        (default {file}`/etc/hydrascale/secrets.yaml`).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # the default path, so the CLI (`hydrascale status`, `hydrascale tailscale <id> -- ...`)
    # finds the same file as the daemon
    environment.etc."hydrascale/config.yaml" = {
      source = settingsFormat.generate "hydrascale.yaml" cfg.settings;
      mode = "0644";
    };

    # namespace traffic is forwarded and masqueraded through the host
    boot.kernel.sysctl."net.ipv4.ip_forward" = lib.mkDefault 1;

    # host side of the per-tailnet veth pairs (vh<hash>)
    networking.networkmanager.unmanaged = lib.mkIf config.networking.networkmanager.enable [
      "interface-name:vh*"
    ];

    systemd.services.hydrascale = {
      description = "Hydrascale multi-tailnet manager";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      reloadTriggers = [ config.environment.etc."hydrascale/config.yaml".source ];
      path = [
        cfg.tailscalePackage
        config.systemd.package
        pkgs.iproute2
        pkgs.iptables
        pkgs.procps
      ];
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} serve --config /etc/hydrascale/config.yaml";
        ExecReload = "${lib.getExe' pkgs.coreutils "kill"} -HUP $MAINPID";
        Restart = "on-failure";
        RestartSec = "5s";
        StateDirectory = "hydrascale";
        WorkingDirectory = "/var/lib/hydrascale";
        # No sandboxing: the daemon creates network namespaces, mounts an
        # overlay over /etc for each namespaced tailscaled, and writes host
        # routes, iptables rules and resolved/hosts entries.
      };
    };
  };
}
